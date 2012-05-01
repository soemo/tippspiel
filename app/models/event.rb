class Event < ActiveRecord::Base
  # Symbolisiert die Ausführung eines Events, z.B. den Lauf des Schedulers.
  # Wird im Scheduler Controller selbst verwendet, um zu dokumentieren, wann welcher Scheduler gelaufen ist

  attr_accessible :event_type

end
