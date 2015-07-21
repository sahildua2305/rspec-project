require 'simplecov'
SimpleCov.start
require 'rspec'
require 'fileutils'
require 'securerandom'

# requires all files recursively inside a directory from current dir
# @param _dir can be relative path like '/lib' or "../lib"
def require_all(_dir)
    Dir[File.expand_path(File.join(File.dirname(File.absolute_path(__FILE__)), _dir)) + "/**/*.rb"].each do |file|
    	require file
    end
end

# inserts a new line into the given file after given line number
# used for inserting variable increment statement into code
def insertAtLineNo(file, line_no, var_name)
	tempfile = File.open("new_file.tmp", 'w')
	f = File.new(file)
	count=0
	f.each do |line|
		count+=1
		if count == line_no
			line << "        $" + var_name.to_s + "+=1\n"
		end
		# puts line
		tempfile<<line
	end
	f.close
	tempfile.close

	FileUtils.mv("new_file.tmp", file)
end

require_all('../lib')
# Dir[__dir__ + '/../lib/*.rb'].each {|file| require file } # WORKS
# require_relative '../lib' # Not working


variables_hash = Hash.new

methods_list = Burger.instance_methods(false)
count=0 # stores count of already added lines
methods_list.each{ |method|
	if method.to_s == "options"
		next
	end
	# Get line number where the method is defined
	file, line = Burger.instance_method(method).source_location
	# Add already inserted number of lines
	actual_line_no = line + count
	# Generate random variable name and arr it to the hash
	var_name = "hr_" + SecureRandom.hex(6)
	variables_hash[method] = var_name
	# Insert the variable increment statement in the file
	insertAtLineNo(file, actual_line_no, var_name)
	# Increment the number of lines written into the file
	count+=1
}

# To convert all key-value pairs from strings into symbols
# variables_hash = Hash[variables_hash.map{|(k,v)| [k.to_sym, v.to_sym]}]

puts variables_hash

RSpec.configure do |config|
  	config.before(:suite) do
  		variables_hash.each do |key, value|
  			var_name = "$#{value}"
  			var_name = var_name.to_sym
  			puts var_name
  			var_name = 0
  			puts var_name
  			$variable = var_name
  		end
	end

	config.after(:suite) do
		variables_hash.each do |key, value|
			var_name = "$#{value}"
			# var_name = var_name.to_sym
			p var_name
			p eval(var_name)
			# puts var_name.to_sym
		end
	end
end