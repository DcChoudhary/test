# =============================================================================
# PARKING LOT SYSTEM — Full Ruby Implementation
# =============================================================================
# HOW TO RUN:
#   ruby parking_lot.rb
#
# This file is self-contained. It defines all classes, then runs a demo
# at the bottom so you can see the system in action immediately.
# =============================================================================

# =============================================================================
# 1. VEHICLE CLASSES
# =============================================================================
# Why a base class?
#   All vehicles share a license_plate and a type. We put that shared
#   behaviour in one place (Vehicle) and let subclasses inherit it.
#   If tomorrow we add a "Bus" type we only write the new class — we don't
#   touch anything else.

class Vehicle
  attr_reader :license_plate, :type

  def initialize(license_plate, type)
    @license_plate = license_plate
    @type          = type # will always be set by the subclass
  end

  def to_s
    # Gives us a readable description, e.g.  "Car [KA-01-AB-1234]"
    "#{self.class.name} [#{@license_plate}]"
  end
end

# Each subclass calls super() and hard-codes its own type symbol.
# Using a symbol (:car) instead of a string ("car") is idiomatic Ruby —
# symbols are immutable, memory-efficient, and perfect for fixed labels.

class Car < Vehicle
  def initialize(license_plate)
    super(license_plate, :car)
  end
end

class Motorcycle < Vehicle
  def initialize(license_plate)
    super(license_plate, :motorcycle)
  end
end

class Truck < Vehicle
  def initialize(license_plate)
    super(license_plate, :truck)
  end
end

# =============================================================================
# 2. PARKING SPOT
# =============================================================================
# Responsibility: knows whether it is occupied and which vehicle is inside.
# It does NOT decide pricing or routing — that belongs elsewhere.

class ParkingSpot
  attr_reader :spot_id, :size, :vehicle

  # size is one of :small, :medium, :large
  def initialize(spot_id, size)
    @spot_id  = spot_id
    @size     = size
    @vehicle  = nil       # nil means the spot is free
  end

  def occupied?
    !@vehicle.nil?        # returns true when a vehicle is parked here
  end

  # Park a vehicle. Raises if the spot is already taken so callers get
  # a clear error instead of silently overwriting the existing vehicle.
  def park!(vehicle)
    raise "Spot #{@spot_id} is already occupied!" if occupied?

    @vehicle = vehicle
    puts "  ✅ #{vehicle} parked in spot #{@spot_id} (#{@size})"
  end

  # Remove whatever vehicle is here and return it so the caller can
  # use it when generating the receipt.
  def vacate!
    raise "Spot #{@spot_id} is already empty!" unless occupied?

    parked = @vehicle
    @vehicle = nil
    puts "  🚗 #{parked} left spot #{@spot_id}"
    parked # return the vehicle
  end

  def to_s
    status = occupied? ? "OCCUPIED by #{@vehicle}" : 'FREE'
    "[#{@spot_id}|#{@size}] #{status}"
  end
end

# =============================================================================
# 3. TICKET
# =============================================================================
# A Ticket is essentially a value object — it just holds data.
# Ruby's Struct generates attr_readers, ==, to_s, and more automatically.
# We add a custom to_s so printed tickets look nice.
#
# Struct.new creates a new class; we assign it to a constant so it behaves
# exactly like a class defined with the `class` keyword.

Ticket = Struct.new(:ticket_id, :vehicle, :spot, :entry_time, :exit_time) do
  # duration_hours is derived from the two timestamps.
  # We ceil() so that even 10 minutes counts as 1 hour — common in real lots.
  def duration_hours
    return 0 unless exit_time

    ((exit_time - entry_time) / 3600.0).ceil
  end

  def to_s
    lines = [
      "--- TICKET #{ticket_id} ---",
      "Vehicle   : #{vehicle}",
      "Spot      : #{spot.spot_id} (#{spot.size})",
      "Entry     : #{entry_time.strftime('%Y-%m-%d %H:%M:%S')}"
    ]
    if exit_time
      lines << "Exit      : #{exit_time.strftime('%Y-%m-%d %H:%M:%S')}"
      lines << "Duration  : #{duration_hours}h"
    else
      lines << 'Status    : Currently parked'
    end
    lines.join("\n")
  end
end

# =============================================================================
# 4. PRICING STRATEGIES
# =============================================================================
# The Strategy pattern: different pricing objects all respond to calculate(ticket).
# Because Ruby uses duck typing, we don't need a shared interface — any object
# with a calculate method works.  This means:
#   - Swapping pricing is one line of code: ParkingLot.instance(pricing: X.new)
#   - Adding a "weekend rate" or "member discount" is a new class, not an edit.

class HourlyPricing
  # Rates in Rupees per hour, keyed by spot size
  RATES = {
    small: 30,
    medium: 50,
    large: 80
  }.freeze # freeze prevents accidental mutation at runtime

  def calculate(ticket)
    rate = RATES[ticket.spot.size]
    fee  = ticket.duration_hours * rate
    puts "  💰 Fee: #{ticket.duration_hours}h × ₹#{rate}/h = ₹#{fee}"
    fee
  end
end

class FlatRatePricing
  # One fixed charge regardless of time or spot size — useful for airports, etc.
  FLAT_FEE = 100

  def calculate(ticket)
    puts "  💰 Flat fee: ₹#{FLAT_FEE}"
    FLAT_FEE
  end
end

# =============================================================================
# 5. PARKING FLOOR
# =============================================================================
# A floor owns a collection of spots and knows how to find a free one.
# Keeping floor logic separate from the lot means we can add floors
# without changing any other class.

class ParkingFloor
  attr_reader :floor_number, :spots

  def initialize(floor_number)
    @floor_number = floor_number
    @spots        = [] # all ParkingSpot objects on this floor
  end

  def add_spot(spot)
    @spots << spot
  end

  # Find the first free spot of the requested size on this floor.
  # Returns nil if none is available — callers must handle that.
  def find_available_spot(size)
    @spots.find { |s| s.size == size && !s.occupied? }
  end

  def available_count
    @spots.count { |s| !s.occupied? }
  end

  def status
    puts "\n  Floor #{@floor_number} (#{available_count}/#{@spots.size} free):"
    @spots.each { |s| puts "    #{s}" }
  end
end

# =============================================================================
# 6. PARKING LOT  (Singleton)
# =============================================================================
# Ruby's built-in Singleton module replaces ParkingLot.new with
# ParkingLot.instance.  Every call to .instance returns the SAME object,
# so there is literally one lot in the whole program — enforced by the language.
#
# Why Singleton?
#   In a real app many parts of the code need the lot (gates, APIs, admin
#   dashboards). Without Singleton you'd pass the lot object around everywhere
#   or risk creating multiple lots by accident.

require 'singleton'

class ParkingLot
  include Singleton

  # SPOT_SIZES_FOR maps a vehicle type to the spot sizes it is allowed to use,
  # ordered from smallest/cheapest to largest.  A motorcycle can fit in any spot;
  # a truck can only use large ones.
  SPOT_SIZES_FOR = {
    motorcycle: %i[small medium large],
    car: %i[medium large],
    truck: %i[large]
  }.freeze

  attr_reader :name

  def initialize
    @name    = 'Ruby Parking Lot'
    @floors  = []
    @tickets = {}   # ticket_id => Ticket  — acts as our in-memory database
    @counter = 0    # used to generate unique ticket IDs
    @mutex   = Mutex.new # prevents race conditions if multiple threads park at once
  end

  # ---- Setup ----------------------------------------------------------

  def add_floor(floor)
    @floors << floor
    self # return self so calls can be chained: lot.add_floor(f1).add_floor(f2)
  end

  # ---- Core operations ------------------------------------------------

  # park_vehicle is the entry-gate action.
  # It finds a spot, marks it occupied, and issues a ticket.
  def park_vehicle(vehicle, pricing_strategy = HourlyPricing.new)
    @mutex.synchronize do # only one thread can execute this block at a time
      spot = find_spot(vehicle.type)
      if spot.nil?
        puts "  ❌ No spot available for #{vehicle}"
        return nil
      end

      spot.park!(vehicle)

      @counter += 1
      ticket_id = "TKT-#{@counter.to_s.rjust(4, '0')}" # e.g. TKT-0001

      ticket = Ticket.new(ticket_id, vehicle, spot, Time.now, nil)
      @tickets[ticket_id] = ticket

      puts ticket
      ticket # return the ticket so the gate can hand it to the driver
    end
  end

  # unpark_vehicle is the exit-gate action.
  # It closes the ticket, calculates the fee, and frees the spot.
  def unpark_vehicle(ticket_id, pricing_strategy = HourlyPricing.new)
    @mutex.synchronize do
      ticket = @tickets[ticket_id]
      if ticket.nil?
        puts "  ❌ Ticket #{ticket_id} not found"
        return nil
      end

      if ticket.exit_time
        puts "  ⚠️  Ticket #{ticket_id} already checked out"
        return nil
      end

      # Struct members are mutable — we update exit_time in place.
      ticket.exit_time = Time.now
      ticket.spot.vacate!

      fee = pricing_strategy.calculate(ticket)
      puts ticket
      fee
    end
  end

  # ---- Status ---------------------------------------------------------

  def status
    puts "\n========== #{@name} STATUS =========="
    @floors.each(&:status) # &:status is shorthand for { |f| f.status }
    puts "===================================\n"
  end

  # ---- Private --------------------------------------------------------
  private

  # Walk every floor and every allowed size until we find a free spot.
  # Floors are checked in order (ground floor first), sizes from smallest
  # to largest (so we don't waste a large spot on a motorcycle).
  def find_spot(vehicle_type)
    allowed_sizes = SPOT_SIZES_FOR[vehicle_type]
    raise ArgumentError, "Unknown vehicle type: #{vehicle_type}" if allowed_sizes.nil?

    allowed_sizes.each do |size|
      @floors.each do |floor|
        spot = floor.find_available_spot(size)
        return spot if spot # found one — stop searching
      end
    end

    nil # nothing found
  end
end

# =============================================================================
# 7. GATE CLASSES  (thin wrappers)
# =============================================================================
# EntryGate and ExitGate are thin facades.  They decouple the "physical"
# gate concept from the lot's internal logic.  In a real app each gate
# might talk to a different database, have its own display screen, etc.

class EntryGate
  def initialize(gate_id, lot = ParkingLot.instance)
    @gate_id = gate_id
    @lot     = lot
  end

  def admit(vehicle)
    puts "\n🚧 EntryGate #{@gate_id}: #{vehicle} arriving"
    @lot.park_vehicle(vehicle)
  end
end

class ExitGate
  def initialize(gate_id, pricing_strategy: HourlyPricing.new, lot: ParkingLot.instance)
    @gate_id          = gate_id
    @pricing_strategy = pricing_strategy
    @lot              = lot
  end

  def release(ticket_id)
    puts "\n🚧 ExitGate #{@gate_id}: processing ticket #{ticket_id}"
    @lot.unpark_vehicle(ticket_id, @pricing_strategy)
  end
end

# =============================================================================
# 8. DEMO / DRIVER CODE
# =============================================================================
# Everything below this line just exercises the classes above.
# In a real Rails app this would be replaced by controllers and a database.

puts "\n" + '=' * 60
puts '  PARKING LOT SYSTEM — DEMO'
puts '=' * 60

# -- Build the lot -------------------------------------------------------
lot = ParkingLot.instance

# Floor 1: mix of spot sizes
floor1 = ParkingFloor.new(1)
floor1.add_spot(ParkingSpot.new('F1-S1', :small))
floor1.add_spot(ParkingSpot.new('F1-S2', :small))
floor1.add_spot(ParkingSpot.new('F1-M1', :medium))
floor1.add_spot(ParkingSpot.new('F1-M2', :medium))
floor1.add_spot(ParkingSpot.new('F1-L1', :large))

# Floor 2: more large spots for trucks
floor2 = ParkingFloor.new(2)
floor2.add_spot(ParkingSpot.new('F2-S1', :small))
floor2.add_spot(ParkingSpot.new('F2-M1', :medium))
floor2.add_spot(ParkingSpot.new('F2-L1', :large))
floor2.add_spot(ParkingSpot.new('F2-L2', :large))

lot.add_floor(floor1).add_floor(floor2)

# -- Show initial state --------------------------------------------------
lot.status

# -- Create vehicles -----------------------------------------------------
bike1  = Motorcycle.new('MH-12-AB-1111')
car1   = Car.new('MH-14-CD-2222')
car2   = Car.new('MH-14-EF-3333')
truck1 = Truck.new('MH-04-GH-4444')

# -- Park vehicles -------------------------------------------------------
puts "\n--- PARKING VEHICLES ---"
entry = EntryGate.new('GATE-A')

t1 = entry.admit(bike1)
t2 = entry.admit(car1)
t3 = entry.admit(car2)
t4 = entry.admit(truck1)

# -- Status after parking ------------------------------------------------
lot.status

# -- Simulate time passing (so fees are non-zero) ------------------------
# We manually adjust entry_time back by 2 hours to simulate a 2-hour stay.
# In production Time.now would naturally advance.
if t1
  t1.entry_time = Time.now - 7200 # 2 hours ago
end
if t2
  t2.entry_time = Time.now - 10_800 # 3 hours ago
end

# -- Exit vehicles -------------------------------------------------------
puts "\n--- VEHICLES LEAVING ---"
exit_gate = ExitGate.new('GATE-B', pricing_strategy: HourlyPricing.new)

exit_gate.release(t1.ticket_id) if t1   # motorcycle, 2h, small spot → ₹60
exit_gate.release(t2.ticket_id) if t2   # car, 3h, medium spot       → ₹150

# -- Flat rate demo ------------------------------------------------------
puts "\n--- FLAT RATE EXIT ---"
flat_exit = ExitGate.new('GATE-C', pricing_strategy: FlatRatePricing.new)
flat_exit.release(t3.ticket_id) if t3 # car, flat ₹100

# -- Final status --------------------------------------------------------
lot.status

# -- Edge case: try to exit the same ticket twice ------------------------
puts "\n--- EDGE CASES ---"
puts 'Trying to re-exit an already-closed ticket:'
exit_gate.release(t1.ticket_id) if t1

puts "\nTrying an unknown ticket:"
exit_gate.release('TKT-9999')
