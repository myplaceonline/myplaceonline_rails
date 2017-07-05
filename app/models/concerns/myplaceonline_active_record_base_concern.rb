module MyplaceonlineActiveRecordBaseConcern
  extend ActiveSupport::Concern
  include ModelHelpersConcern
  include AllowExistingConcern
  
  included do
    def self.build(params = nil)
      self.dobuild(params)
    end
    
    def self.dobuild(params = nil)
      
      # We don't actually pass in params to new() because that will cause
      # a ForbiddenAttributesError. They may be set separately using
      # assign_attributes. The params are just passed in so that the model
      # has a chance to access form values
      
      result = self.new
      
      # If there's an encrypt attribute, then set the default
      # based on user preference, if available
      if result.respond_to?("encrypt")
        usr = User.current_user
        if !usr.nil?
          result.encrypt = usr.encrypt_by_default
        end
      end
      
      result
    end

    def file_folders_parent
      nil
    end
    
    def file_folders
      [I18n.t("myplaceonline.category." + self.class.table_name), self.display]
    end
    
    def file_folders_final
      if file_folders_parent.nil?
        self.file_folders
      else
        self.send(self.file_folders_parent).file_folders + [self.display]
      end
    end
    
    def self.allow_super_user_search?
      false
    end
  end
  
  class_methods do
    
    def check_attributes(model:, attributes:)
      if model.respond_to?("attributes_blank?")
        model.attributes_blank?(attributes: attributes)
      else
        raise "Model #{model} doesn't have method attributes_blank?(attributes:)"
      end
    end
    
    def child_property(
      name:,
      model: nil,
      allow_destroy: true,
      autosave: true,
      destroy_dependent: nil,
      required: false
    )
      if model.nil?
        model = Object.const_get(name.to_s.camelize)
      end
      
      MyplaceonlineActiveRecordBaseConcern.set_attributes_model_mapping(klass: self, name: name, model: model)
      
      if destroy_dependent
        destroy_dependent = :destroy
      end
      
      belongs_to(
        name,
        class_name: model.name,
        autosave: autosave,
        dependent: destroy_dependent
      )

      # dup the attributes so that the attributes_blank? method can call delete_if/keep_if without consequence
      accepts_nested_attributes_for(
        name,
        allow_destroy: allow_destroy,
        reject_if: lambda {|attributes| check_attributes(attributes: attributes.dup, model: model)}
      )
      
      allow_existing(name: name)
      
      if required
        validates name, presence: true
      end
    end
    
    def child_property_models
      MyplaceonlineActiveRecordBaseConcern.get_attributes_model_mappings(klass: self)
    end
    
    # dependent:
    #   :destroy causes all the associated objects to also be destroyed.
    #   :delete_all causes all the associated objects to be deleted directly from the database (so callbacks will not be executed).
    #   :nullify causes the foreign keys to be set to NULL. Callbacks are not executed.
    #   :restrict_with_exception causes an exception to be raised if there are any associated records.
    #   :restrict_with_error causes an error to be added to the owner if there are any associated objects.
    def child_properties(
      name:,
      model: nil,
      allow_destroy: true,
      autosave: true,
      dependent: :destroy,
      required: false,
      sort: "updated_at DESC",
      foreign_key: nil
    )
      if model.nil?
        model = Object.const_get(name.to_s.singularize.camelize)
      end
      
      MyplaceonlineActiveRecordBaseConcern.set_attributes_model_mapping(klass: self, name: name, model: model)
      
      if foreign_key.nil?
        has_many(name, -> { order(sort) }, autosave: autosave, dependent: dependent)
      else
        has_many(name, -> { order(sort) }, autosave: autosave, dependent: dependent, foreign_key: foreign_key)
      end
      
      accepts_nested_attributes_for(
        name,
        allow_destroy: allow_destroy,
        reject_if: lambda {|attributes| check_attributes(attributes: attributes.dup, model: model)}
      )
      
      allow_existing_children(name)
    end
    
    def child_pictures(name: nil)
      child_files(name: name, suffix: "pictures")
    end
    
    def child_file(parent:, class_name: nil)
      if class_name.nil?
        belongs_to parent
      else
        belongs_to parent, class_name: class_name
      end

      child_property(name: :identity_file, required: true)
      
      define_method(:display) do
        self.identity_file.display
      end
      
      define_method(:update_file_folders) do
        p = self.send(parent)
        Rails.logger.debug{"child_file; parent: #{p.inspect}"}
        if !p.nil?
          folders = p.file_folders_final
          Rails.logger.debug{"child_file; folders: #{folders}"}
          put_file_in_folder(self, folders)
        end
      end

      after_commit :update_file_folders, on: [:create, :update]
    end
    
    def child_files(name: nil, suffix: "files")
      if name.nil?
        name = (self.name.tableize.singularize + "_" + suffix).to_sym
      end
      
      child_properties(name: name, sort: "position ASC, updated_at ASC")

      update_method_name = ("update_file_folders_" + name.to_s).to_sym
      #update_method_name = :update_method_name
      
      define_method(update_method_name) do
        Rails.logger.debug{"Finding folders for: #{name}, file_folders_parent: #{file_folders_parent}"}
        folders = self.file_folders_final
        if !folders.nil? && folders.length > 0
          Rails.logger.debug{"Called with folders: #{folders}"}
          put_files_in_folder(self.send(name), folders)
        else
          Myp.warn("Could not evaluate folders for name: #{name}, file_folders_parent: #{file_folders_parent}, self: #{Myp.debug_print(self)}")
        end
      end
      
      after_commit update_method_name, on: [:create, :update]
    end

    def attributes_blank?(attributes:)
      Rails.logger.debug{"#{name}.attributes_blank? attributes: #{attributes}"}
      result = attributes.all?{|key, value| check_attributes_blank_and_children?(key: key, value: value) }
      Rails.logger.debug{"#{name}.attributes_blank? result: #{result}"}
      result
    end
    
    def check_attributes_blank_and_children?(key:, value:)
      key = key.to_s
      if key.end_with?("_attributes")
        key = key[0..key.index("_attributes")-1]
        model = MyplaceonlineActiveRecordBaseConcern.get_attributes_model_mapping(klass: self, name: key.to_sym)
        if model.nil?
          model = Object.const_get(key.camelize)
        end
        result = model.attributes_blank?(attributes: value)
      elsif all_skip_check_attributes.length > 0 && !all_skip_check_attributes.index(key).nil?
        result = true
      else
        result = value.blank?
      end
      if !result
        Rails.logger.debug{"#{name}.check_attributes_blank_and_children? non-blank key: #{key}, value: #{value}"}
      end
      result
    end
    
    def all_skip_check_attributes
      skip_check_attributes + ["_updatetype"]
    end

    def skip_check_attributes
      []
    end
  end

  @@attributes_model_map = {}
  
  def self.set_attributes_model_mapping(klass:, name:, model:)
    map = @@attributes_model_map[klass]
    if map.nil?
      map = {}
      @@attributes_model_map[klass] = map
    end
    
    #Rails.logger.debug{"Add to attributes model map; name: #{name}, model: #{model}, class: #{klass.name}"}
      
    @@attributes_model_map[klass][name] = model
  end

  def self.get_attributes_model_mapping(klass:, name:)
    result = @@attributes_model_map.dig(klass, name)
    #Rails.logger.debug{"get_attributes_model_mapping; klass: #{klass.name}, name: #{name}, result: #{result}"}
    result
  end
  
  def self.get_attributes_model_mappings(klass:)
    result = @@attributes_model_map[klass]
    if result.nil?
      result = {}
    end
    #Rails.logger.debug{"get_attributes_model_mappings; klass: #{klass.name}, result: #{result}"}
    result
  end
end
