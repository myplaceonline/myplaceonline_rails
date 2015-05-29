class AddIdentityReferencs < ActiveRecord::Migration
  def process_input(x, inp)
    if !inp.nil?
      inp.identity_id = x.identity_id
      inp.save!
      
    end
  end

  def process_operand(x, operand)
    if !operand.nil?
      operand.identity_id = x.identity_id
      operand.save!
      process_element(x, operand.calculation_element)
      process_input(x, operand.calculation_input)
    end
  end

  def process_element(x, el)
    if !el.nil?
      el.identity_id = x.identity_id
      el.save!
      process_operand(x, el.left_operand)
      process_operand(x, el.right_operand)
    end
  end

  def empty_identity(x)
    puts "Empty identity for " + x.inspect
  end

  def change
    add_reference :apartment_leases, :identity, index: true
    Apartment.all.each{|x| x.apartment_leases.each{|y|
      if !x.identity.nil?
        y.identity_id = x.identity_id
        y.save!
      else
        empty_identity(x)
      end
    } }
    add_reference :calculation_elements, :identity, index: true
    add_reference :calculation_inputs, :identity, index: true
    add_reference :calculation_operands, :identity, index: true
    CalculationForm.all.each{|x|
      if !x.identity.nil?
        x.calculation_inputs.each{|y|
          process_input(x, y)
        }
        process_element(x, x.root_element)
      else
        empty_identity(x)
      end
    }
    add_reference :conversations, :identity, index: true
    add_reference :identity_emails, :identity, index: true
    add_reference :identity_locations, :identity, index: true
    Contact.all.each{|x|
      if !x.identity.nil?
        x.conversations.each{|y|
          y.identity_id = x.identity_id
          y.save!
        }
        if !x.ref.nil?
          x.ref.identity_emails.each{|y|
            y.identity_id = x.identity_id
            y.save!
          }
          x.ref.identity_locations.each{|y|
            y.identity_id = x.identity_id
            y.save!
          }
          x.ref.identity_phones.each{|y|
            y.identity_id = x.identity_id
            y.save!
          }
        end
      else
        empty_identity(x)
      end
    }
    add_reference :list_items, :identity, index: true
    List.all.each{|x| x.list_items.each{|y|
      if !x.identity.nil?
        y.identity_id = x.identity_id
        y.save!
      else
        empty_identity(x)
      end
    } }
    add_reference :location_phones, :identity, index: true
    Location.all.each{|x| x.location_phones.each{|y|
      if !x.identity.nil?
        y.identity_id = x.identity_id
        y.save!
      else
        empty_identity(x)
      end
    } }
    add_reference :password_secrets, :identity, index: true
    Password.all.each{|x| x.password_secrets.each{|y|
      if !x.identity.nil?
        y.identity_id = x.identity_id
        y.save!
      else
        empty_identity(x)
      end
    } }
    add_reference :vehicle_services, :identity, index: true
    Vehicle.all.each{|x| x.vehicle_services.each{|y|
      if !x.identity.nil?
        y.identity_id = x.identity_id
        y.save!
      else
        empty_identity(x)
      end
    } }
  end
end
