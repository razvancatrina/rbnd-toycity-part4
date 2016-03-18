require_relative 'udacidata'

class Product < Udacidata
  create_finder_methods :brand, :name
  attr_reader :id, :price, :brand, :name

  def initialize(opts={})

    # Get last ID from the database if ID exists
    get_last_id
    # Set the ID if it was passed in, otherwise use last existing ID
    @id = opts[:id] ? opts[:id].to_i : @@count_class_instances
    # Increment ID by 1
    auto_increment if !opts[:id]
    # Set the brand, name, and price normally
    @brand = opts[:brand]
    @name = opts[:name]
    @price = opts[:price]
  end

  def self.create(product_information={})
      @file_path = File.dirname(__FILE__) + "/../data/data.csv"
      #@database_content = CSV.read(file)
      #puts @database_content.inspect

      @product = Product.new(product_information)

      CSV.open(@file_path, "ab") do |csv|
      csv << [@product.id, @product.brand, @product.name, @product.price]
      end

      return @product      
  end

  def self.all
    all_products = []

    database_content = CSV.read(@file_path).drop(1)
    database_content.each do |item|
      all_products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    end

    return all_products
  end

  def self.first(number_of_items = 0)
    if number_of_items == 0
        item = CSV.read(@file_path).drop(1).first
        Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    else
        products = []

        data = CSV.read(@file_path).drop(1).slice(0, number_of_items)
        data.each do |item|
          products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
        end

        return products
    end
  end

  def self.last(number_of_items = 0)
    if number_of_items == 0
        item = CSV.read(@file_path).drop(1).last
        Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    else
        products = []

        data = CSV.read(@file_path).drop(1).last(number_of_items)
        data.each do |item|
          products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
        end

        return products
    end
  end

  def self.find(product_id)
      data = CSV.read(@file_path).drop(1)
      product = data.select{ |item| item[0] == product_id.to_s}.first
      return Product.new({id: product[0], brand: product[1], name: product[2], price:product[3]})
  end

  def self.destroy(product_id)
      deleted_product = Product.find(product_id)
      if deleted_product
        data = CSV.table(@file_path)
        data.delete_if do |row|
          row[:id] == product_id
        end
        
        File.open(@file_path, 'w') do |f|
          f.write(data.to_csv)
        end
      end

      return deleted_product
  end

  #def self.find_by_brand(brand_name)
  #end

  private

    # Reads the last line of the data file, and gets the id if one exists
    # If it exists, increment and use this value
    # Otherwise, use 0 as starting ID number
    def get_last_id
      file = File.dirname(__FILE__) + "/../data/data.csv"
      last_id = File.exist?(file) ? CSV.read(file).last[0].to_i + 1 : nil
      @@count_class_instances = last_id || 0
    end

    def auto_increment
      @@count_class_instances += 1
    end

end
