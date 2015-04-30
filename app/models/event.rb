# -*- encoding : utf-8 -*-
class Event < ActiveRecord::Base
  # Symbolisiert die Ausführung eines Events, z.B. den Lauf des Schedulers.
  # Wird im Scheduler Controller selbst verwendet, um zu dokumentieren, wann welcher Scheduler gelaufen ist
  # TODO soeren 30.04.15 wird das noch nach #94 benoetigt?
end
