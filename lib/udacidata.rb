require_relative 'find_by'
require_relative 'errors'
require 'csv'

class Udacidata
	create_finder_methods :brand, :name
	@@file_path = File.dirname(__FILE__) + "/../data/data.csv"

  def self.create(product_information={})
      product_from_db = self.all.select{|p| p.name == product_information[:name] && p.brand == product_information[:brand] && p.price == product_information[:price]}.first

      if product_from_db
        @product = product_from_db
      else
        @product = Product.new(product_information)
      end
      @product = Product.new(product_information)

      # the save to csv should happen only when the product is not in the database, otherwise duplicates
      # will be added. However if the code does not add duplicates the test named will test_create_method_adds_to_database will fail
      # is there something I miss here?
    	CSV.open(@@file_path, "a+") do |csv|
    	 csv << [@product.id, @product.brand, @product.name, @product.price]
    	end

      return @product      
  end

  def self.all
    all_products = []
    database_content = CSV.read(@@file_path).drop(1)
    database_content.each do |item|
      all_products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    end

    return all_products
  end

  def self.first(number_of_items = 0)
    if number_of_items == 0
        item = CSV.read(@@file_path).drop(1).first
        Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    else
        products = []

        data = CSV.read(@@file_path).drop(1).slice(0, number_of_items)
        data.each do |item|
          products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
        end

        return products
    end
  end

  def self.last(number_of_items = 0)
    if number_of_items == 0
        item = CSV.read(@@file_path).drop(1).last
        Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
    else
        products = []

        data = CSV.read(@@file_path).drop(1).last(number_of_items)
        data.each do |item|
          products << Product.new({id: item[0], brand: item[1], name: item[2], price:item[3]})
        end

        return products
    end
  end

  def self.find(product_id)
      data = CSV.read(@@file_path).drop(1)
      product = data.select{ |item| item[0] == product_id.to_s}.first
      if !product
        raise ProductNotFoundError
      end
      return Product.new({id: product[0], brand: product[1], name: product[2], price:product[3]})
  end

  def self.destroy(product_id)
      deleted_product = Product.find(product_id)
      if deleted_product
        data = CSV.table(@@file_path)
        data.delete_if do |row|
          row[:id] == product_id
        end
        
        File.open(@@file_path, 'w') do |f|
          f.write(data.to_csv)
        end
      end

      return deleted_product
  end

  def self.where(params = {})
    products = []
    if params.keys[0].to_s == "brand"
      products = Product.all.select{ |item| item.brand == params[params.keys[0]]}
    elsif params.keys[0].to_s == "name"
      products = Product.all.select{ |item| item.name == params[params.keys[0]]}
    end
    return products
  end

  def update(params = {})
    data = CSV.table(@@file_path)
    data.each do |row|
      if row[:id] == @id
        if params[:price]
          row[:price] = params[:price]
        end

        if params[:brand]
          row[:brand] = params[:brand]
        end
      end
    end

    File.open(@@file_path, 'w') do |f|
          f.write(data.to_csv)
    end
    
    return Product.find(@id)
  end
end
