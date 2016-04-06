require 'csv'

# Represents a person in an address book.
# The ContactList class will work with Contact objects instead of interacting with the CSV file directly
class Contact
  
  CSV_FILE = './contacts.csv'

  attr_accessor :name, :email, :id
  
  # Creates a new contact object
  # @param name [String] The contact's name
  # @param email [String] The contact's email address
  def initialize(name, email, id = nil)
    # Assign parameter values to instance variables.
    @name = name
    @email = email
    @id = id
  end

  # Provides functionality for managing contacts in the csv file.
  class << self

    # Opens 'contacts.csv' and creates a Contact object for each line in the file (aka each contact).
    # @return [Array<Contact>] Array of Contact objects
    def all
      # Return an Array of Contact instances made from the data in 'contacts.csv'.
      list = []
      CSV.foreach(CSV_FILE) do |contact|
        name = contact[0]
        email = contact[1]
        id = $.
        contact = Contact.new(name,email,id)
        list << contact
      end
      list
    end

    # Creates a new contact, adding it to the csv file, returning the new contact.
    # @param name [String] the new contact's name
    # @param email [String] the contact's email
    def create(name, email, phones = nil)
      # Instantiate a Contact, add its data to the 'contacts.csv' file, and return it.
      return nil unless search(email).empty?
      size = CSV.read(CSV_FILE).size
      csv = CSV.open(CSV_FILE, 'a')
      if phones.empty?
        csv << [name,email]
      else
        csv << [name,email,phones]
      end
      id = size + 1

      Contact.new(name, email, id)
    end
    
    # Find the Contact in the 'contacts.csv' file with the matching id.
    # @param id [Integer] the contact id
    # @return [Contact, nil] the contact with the specified id. If no contact has the id, returns nil.
    def find(id)
      # Find the Contact in the 'contacts.csv' file with the matching id.
      csv_array = CSV.read(CSV_FILE)
      csv_array[id - 1]
    end
    
    # Search for contacts by either name or email.
    # @param term [String] the name fragment or email fragment to search for
    # @return [Array<Contact>] Array of Contact objects.
    def search(term)
      # Select the Contact instances from the 'contacts.csv' file whose name or email attributes contain the search term.
      Contact.all.select do |contact|
        contact.name =~ /#{term}/i || contact.email =~ /#{term}/i
      end
    end

  end

end