#!/usr/bin/env ruby

require_relative 'contact'
require 'byebug'

# Interfaces between a user and their contact list. Reads from and writes to standard I/O.
class ContactList

	attr_accessor :contacts

  # TODO: Implement user interaction. This should be the only file where you use `puts` and `gets`.
  def display_menu
  	puts "Here is a list of available commands:"
  	puts "\tnew    - Create a new contact"
  	puts "\tlist   - List all contacts"
  	puts "\tshow   - Show a contact"
  	puts "\tsearch - Search contacts"
  	ARGV[0],ARGV[1] = gets.chomp.split(' ')
  	ContactList.new.options
  end

  def options
  	case ARGV[0]
  	when "list"
  		list_all
  	when "new"
  		create_new
  	when "show"
  		show_contact
  	when "search"
  		search_contact
  	end
  end	

  def initialize
  	@contacts = Contact.all
  end

  def list_all
  	list(contacts)
	end

	def list(contacts_to_list)
		size = contacts_to_list.size
		while contacts_to_list.size > 5
			five_contacts = contacts_to_list.shift(5)
			five_contacts.each do |contact|
				puts "#{contact.id}: #{contact.name} (#{contact.email})"
			end
			print "Press enter to continue"
			STDIN.gets.chomp
		end
		# 
		puts "---"
		puts "#{size} contacts total"
	end

	def create_new
		puts "Enter full name:"
		name = STDIN.gets.chomp
		puts "Enter email address:"
		email = STDIN.gets.chomp
		puts "Enter phone types and numbers separated by a space (optional: leave blank to skip)"
		puts "Ex.:"
		puts "work 415-456-9876 home 645-874-0989 mobile 765-987-3478"
		phones = STDIN.gets.chomp
		contact = Contact.create(name, email, nil, phones)
		if contact.nil?
			puts "Unable to create contact, please ensure email is unique."
		else
			puts "Contact #{contact.name} created successfully with id #{contact.id}!"
		end
	end

	def show_contact
		unless ARGV[1] =~ /^\d+$/
			puts "Contact ID must be a number!"
			return
		end
		contact = Contact.find(ARGV[1].to_i)
		if contact
			puts contact
		else
			puts "Contact not found!"
		end
	end

	def search_contact
		found_contacts = Contact.search(ARGV[1])
		if found_contacts
			list(found_contacts)
		else
			puts "No contacts matched your search criteria!"
		end

	end

end

if ARGV.empty?
	ContactList.new.display_menu
else
	ContactList.new.options
end