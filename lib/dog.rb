class Dog

  attr_accessor :name, :breed
  attr_reader :id

  def initialize(name:, breed:, id: nil)
    @name = name
    @breed = breed
    @id = id
  end

  def self.create_table
    sql = "CREATE TABLE dogs (id INTEGER PRIMARY KEY, name TEXT, breed TEXT)"
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE dogs")
  end

  def save

    sql = "INSERT INTO dogs (name, breed) VALUES (?, ?)"
    DB[:conn].execute(sql, self.name, self.breed)

    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs").flatten[0]
    self
  end

  def self.create(name:, breed:)
    dog = Dog.new(name: name, breed: breed)
    dog.save
  end

  def self.find_by_id(id)
    sql = "SELECT * from dogs WHERE id = ?"

    row = DB[:conn].execute(sql, id).flatten
    dog =  Dog.new(name: row[1], breed: row[2], id: row[0])
  end

  def self.find_or_create_by(name:, breed:)
    sql = "SELECT * from dogs WHERE name = ?"
    row = DB[:conn].execute(sql, name).flatten
    if !row.empty?
        Dog.new(name: row[1], breed: row[2], id: row[0])
    else

      Dog.create(name: name, breed: breed)
    end
  end



end
