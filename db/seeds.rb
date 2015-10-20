User.create(name: "The bit corps", phone: '4498961443', role: 'administrator', email: "dev@thebitcorps.com", password: "12345678", password_confirmation: "12345678")
User.create(name: 'Juan Antonio Cruz de la Rivera', phone: '4498663265', role: 'resident', email: 'resident@correo.com', password: '12345678', password_confirmation: '12345678')
User.create(name: 'Pedro Jose Jimenez de la Rivera', phone: '4498663265', role: 'resident', email: 'resident1@correo.com', password: '12345678', password_confirmation: '12345678')
Construction.create(title: "Kinder",address: 'Calle #123', contract_amount: 4000000, start_date: '2015-05-14', finish_date: '2015-12-16', user_id: User.second.id)
Construction.create(title: "Escuela",address: 'Calle #123', contract_amount: 4000000, start_date: '2015-04-04', finish_date: '2015-10-30', user_id: User.second.id)
Construction.create(title: "Prepa",address: 'Calle #123', contract_amount: 4000000, start_date: '2015-06-12', finish_date: '2015-11-05', user_id: User.second.id)

MeasureUnit.create(unit: 'Metros cuadrados', abbreviation: 'M2')
MeasureUnit.create(unit: 'Kilogramos', abbreviation: 'Kg')
MeasureUnit.create(unit: 'Piezas', abbreviation: 'Pzas')

Material.create(name: "Madera", description: "10x10", measure_unit_ids: [1])
Material.create(name: "Madera", description: "20x120", measure_unit_ids: [1])
Material.create(name: "Semento", description: "Gris", measure_unit_ids: [2])
Material.create(name: "Cal", description: "Blanca", measure_unit_ids: [2])
Material.create(name: "Ladrillo", description: "Naranja", measure_unit_ids: [3])
Material.create(name: "Tornillo", description: "12", measure_unit_ids: [3])
Material.create(name: "Clavo", description: "10", measure_unit_ids: [2])


Provider.create(name: "Aceros Rodriguez", address: "Calle Falsa #123", telephone: "9-10-10-10", email: "acerosr@correo.com")
Provider.create(name: "Cemex", address: "Calle Falsa #123", telephone: "9-10-10-10", email: "Cemex@correo.com")
Provider.create(name: "Comex", address: "Calle Falsa #123", telephone: "9-10-10-10", email: "Comex@correo.com")
Provider.create(name: "Materiales Vasques", address: "Calle Falsa #123", telephone: "9-10-10-10", email: "vasques@correo.com")
