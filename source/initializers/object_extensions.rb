class Object
  def returning(object)
    yield object
    object
  end
end