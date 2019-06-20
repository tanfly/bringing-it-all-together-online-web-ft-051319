class Dog 
  
  attr_accessor :name, :breed, :id
  
  def initialize(id: nil, name:, breed:)
    @name = name 
    @breed = breed 
    @id = id
  end
  
  def self.create_table
    sql = <<-SQL 
    CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.drop_table
    sql = <<-SQL 
    DROP TABLE IF EXISTS dogs 
    SQL
    DB[:conn].execute(sql)
  end
  
  def self.new_from_db
    
  end
  
  def update 
    sql = <<-SQL
      UPDATE dogs SET name = ?, breed = ? 
      WHERE id = ? 
    SQL
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end 
  
  def save
    if self.id 
      self.update 
    else 
      sql = <<-SQL 
      INSERT INTO dogs(name, breed) 
      VALUES (?, ?) 
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end
  
  def self.new_from_db(row)
    dog = Dog.new(id: row[0], name: row[1], breed: row[2])
  end 
  
  
  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM dogs 
      WHERE name = ?
    SQL
    DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first 
  end 
  
end