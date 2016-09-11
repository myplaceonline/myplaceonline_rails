class CreateContactsForConnections < ActiveRecord::Migration
  def change
    Connection.where(connection_status: Connection::STATUS_CONNECTED).each do |connection|
      if connection.contact.nil?
        MyplaceonlineExecutionContext.do_identity(connection.identity) do
          connection.contact = Connection.create_contact(connection.user.email)
          connection.save!
        end
      end
    end
  end
end
