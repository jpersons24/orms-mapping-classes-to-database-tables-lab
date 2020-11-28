class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]  

  attr_accessor :name, :grade
  attr_reader :id

  # id=nil because id will be automatically assigned and incremented each time the instance is mapped to table row
  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  # class method to create table within database ==> DB[:conn]
  # set sql variable equal to SQL statement using a heredoc
  # execute your SQL statement on the DB[:conn] using the execut method that is installed with the sqlite3 gem
  def self.create_table

    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id INTEGER PRIMARY KEY,
        name TEXT,
        grade TEXT
      )
      SQL
      DB[:conn].execute(sql)

  end

  # sets sql variable equal to a SQL statement
  # run execute method on DB[:conn] passing sql variable as argument
  def self.drop_table

    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)

  end

  # instance method that sets sql variable equal to SQL statemnt
  # uses bound parameters to pass in Student instances name and grade attributes
  # runs execute method on DB[:conn] passing sql variable, the instance's name attribute, the instances grade attribute
  # sets @id variable equal to the key of the last row inserted to give @id value within the initialize method
  def save

    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]

  end

  # use keyowrd arguments of name:, grade:
  # creates a Student instance using the keyword arguments
  # save new Student instance using the .save method
  def self.create(name:, grade:)

    student = Student.new(name, grade)
    student.save
    student

  end

end
