puts "Iniciando..."

if Rails.env.development?
  puts "Limpiando Base de Datos..."
  Installation.destroy_all
  Technician.destroy_all
  User.destroy_all
  puts " Base de Datos Limpia"
end

puts "Creando  administrador..."
admin = User.create!(
  email: 'admin@somos.com',
  password: '123456',
  name: 'Administrador Principal',
  role: 'admin'
)
puts "Administrador creado: #{admin.email} - #{admin.role}"

puts "Creando técnicos..."
technicians = [
  { name: 'Santiago Garzon', email: 'santiago.g@somos.com', phone: '+57 301 555 5555', active: true },
  { name: 'Ivan Plazas', email: 'ivan.p@somos.com', phone: '+57 302 999 9999', active: true },
  { name: 'Santiago Arias', email: 'santiago.a@somos.com', phone: '+57 303 333 3333', active: true },
  { name: 'Angie Bautista', email: 'angie.b@somos.com', phone: '+57 304 222 2222', active: true },
  { name: 'Ferney Martinez', email: 'ferney.m@somos.com', phone: '+57 305 555 5555', active: true }
]

created_technicians = technicians.map do |tech_data|
  technician = Technician.create!(tech_data)
  puts "Técnico creado: #{technician.name}"
  technician
end

puts "Creando instalaciones..."

# Fechas para las próximas 2 semanas (solo días laborales)
dates = (Date.current..2.weeks.from_now.to_date).to_a.reject { |date| date.saturday? || date.sunday? }

available_times = ['08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00']

customers = [
  { name: 'Conjunto Ocobos', address: 'Calle 85 #12-34, Bogotá', phone: '+57 321 444 5555' },
  { name: 'Oporto apartaments', address: 'Carrera 15 #67-89, Medellín', phone: '+57 302 999 9999' },
  { name: 'Torres de bacatá', address: 'Avenida 6 #45-12, Bogotá', phone: '+57 305 555 5555' },
  { name: 'Clínica Dental Sonríe', address: 'Calle 72 #23-45, Bogotá', phone: '+57 314 123 4567' },
  { name: 'Medellin towers', address: 'Carrera 9 #34-56, Medellín', phone: '+57 302 239 4588' },
  { name: 'Multifamiliares meta', address: 'Calle 45 #78-90, Medellín', phone: '+57 321 789 0123' },
  { name: 'Academia Smart', address: 'Avenida 19 #56-78, Bogotá', phone: '+57 320 890 1234' },
  { name: 'Centro vacacional bachue', address: 'Calle 123 #45-67, Bogotá', phone: '+57 304 901 2345' },
  { name: 'Salón de Belleza Glamour', address: 'Carrera 7 #89-01, Bogotá', phone: '+57 305 012 3456' },
  { name: 'Gimnasio Fitness Pro', address: 'Calle 34 #12-34, Medellín', phone: '+57 300 123 4567' }
]

# Crear instalaciones variadas
installations_data = []

# Algunas instalaciones pendientes (sin técnico)
5.times do
 customer = customers.sample
  date = dates.sample
  start_time = available_times.sample
  
  installations_data << {
    customer_name: customer[:name],
    customer_address: customer[:address],
    customer_phone: customer[:phone],
    scheduled_date: date,
    start_time: Time.parse(start_time),
    duration_hours: [1, 2, 3].sample,
    status: 'pending',
    technician: nil,
    notes: 'Instalación nueva solicitada por el cliente'
  }
end
8.times do
  customer = customers.sample
  date = dates.sample
  start_time = available_times.sample
  technician = created_technicians.select(&:active).sample
  
  installations_data << {
    customer_name: customer[:name],
    customer_address: customer[:address],
    customer_phone: customer[:phone],
    scheduled_date: date,
    start_time: Time.parse(start_time),
    duration_hours: [1, 2, 3].sample,
    status: 'assigned',
    technician: technician,
    notes: "Asignado a #{technician.name}"
  }
end
past_dates = (1.month.ago.to_date..1.day.ago.to_date).to_a.reject { |date| date.saturday? || date.sunday? }.last(10)
6.times do
  customer = customers.sample
  date = past_dates.sample
  start_time = available_times.sample
  technician = created_technicians.select(&:active).sample
  
  installations_data << {
    customer_name: customer[:name],
    customer_address: customer[:address],
    customer_phone: customer[:phone],
    scheduled_date: date,
    start_time: Time.parse(start_time),
    duration_hours: [1, 2, 3].sample,
    status: 'completed',
    technician: technician,
    notes: "Instalación completada exitosamente por #{technician.name}"
  }
end
installations_data.each do |installation_data|
  begin
    installation = Installation.create!(installation_data)
    status_text = case installation.status
                  when 'pending' then 'PENDIENTE'
                  when 'assigned' then 'ASIGNADA'
                  when 'completed' then 'COMPLETADA'
                  end
    puts "#{status_text} - Instalación creada: #{installation.customer_name} - #{installation.scheduled_date}"
  rescue => e
    puts "Error creando instalación: #{e.message}"
  end
end

puts "\nResumen de datos creados:"
puts "Usuarios: #{User.count}"
puts "Técnicos: #{Technician.count} (#{Technician.active.count} activos)"
puts "Instalaciones: #{Installation.count}"
puts "  Pendientes: #{Installation.pending.count}"
puts "  Asignadas: #{Installation.assigned.count}"
puts "  Completadas: #{Installation.completed.count}"

puts "\nSeeds completados exitosamente!"
puts "Puedes iniciar sesión con:"
puts "   Email: admin@somos.com"
puts "   Password: 123456"
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
