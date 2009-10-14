module Utility


module Storage

  STORAGE_FILE = File.join(ENV['HOME'], 'ruby', 'storage.txt')
  Storage = {}

  #Persistently store :value under :key.
  #Replaces old value, if present.
  def save(key, value)
    storage.transaction {storage[key] = value}
  end

  #Retrieve a value from the persistent store.
  def load(key)
    #Open the persistent store read-only, and return the value under the given key.
    value = nil
    storage.transaction(true) {value = storage[key]}
    fail "'#{key}' not found in storage." if value == nil
    value
  end

  #Delete a value from the persistent store.
  def delete(key)
    storage.transaction {storage.delete(key)}
  end

  #List keys in the persistent store.
  def list
    storage.transaction {return storage.roots}
  end

  private

    #Cached copy of PStore.
    def storage
      require 'yaml/store'
      Storage[object_id] ||= YAML::Store.new(STORAGE_FILE)
    end

end


end #module Utility
