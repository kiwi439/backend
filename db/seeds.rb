# frozen_string_literal: true

User.create!([{ email: 'andrzej123@gmail.com', password: '1234Hbjkadasd', avatars: [] },
              { email: 'pawel123@gmail.com', password: '1234Hbjkajjkkaasd', avatars: [] }])

ProductCategory.create!([{ name: 'construction_chemicals' },
                         { name: 'foundation_zone' },
                         { name: 'roof_zone' },
                         { name: 'tools' },
                         { name: 'stairway' }])

Opinion.create!([
  {
    content: 'Szeroki wybór oraz miła obsługa klienta. Napewno tu wrócę',
    mark: 5,
    user: User.find_by!(email: 'andrzej123@gmail.com')
  },
  {
    content: 'Szybka dostawa, polecam.',
    mark: 4,
    user: User.find_by!(email: 'pawel123@gmail.com')
  }
])

construction_chemicals_category = ProductCategory.find_by!(name: 'construction_chemicals')
foundation_zone_category = ProductCategory.find_by!(name: 'foundation_zone')
roof_zone_category = ProductCategory.find_by!(name: 'roof_zone')
tools_category = ProductCategory.find_by!(name: 'tools')
stairway_category = ProductCategory.find_by!(name: 'stairway')

PROMOTED_FROM = Time.zone.parse('2022-10-27 13:18:43.685298')
PROMOTED_TO = Time.zone.parse('2066-10-27 13:18:43.685298')
VAT_RATE = 23

Product.create!([
  {
    name: 'Głądź gipsowa',
    price: 212.55,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/gladz_gipsowa.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Grunt głęboko penetrujący',
    price: 174.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/grunt_gleboko_penetrujacy.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE,
    promoted_from: PROMOTED_FROM,
    promoted_to: PROMOTED_TO
  },
  {
    name: 'Klej do dociepleń',
    price: 150.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/klej_do_dociepleń.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Klej do styropianu',
    price: 150.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/klej_do_styropianu.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Tynk akrylowy',
    price: 120.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/tynk akrylowy.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE,
    promoted_from: PROMOTED_FROM,
    promoted_to: PROMOTED_TO
  },
  {
    name: 'Tynk mozaikowy',
    price: 110.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/tynk_mozaikowy.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Tynk nanosilikonowy',
    price: 80.99,
    available_quantity: 10_000,
    product_category: construction_chemicals_category,
    picture_key: 'images/products/constuction_chemicals/tynk_nanosilikonowy.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Bloczek Termalika',
    price: 124.99,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/bloczke_termalika.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Folia kubełkowa',
    price: 250.00,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/folia_kubełkowa.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Powłoka przeciwwilgociowa',
    price: 600.00,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/powłoka_przeciwwilgociowa.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Syropian fundamentowy 15 cm',
    price: 150.00,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/styropian_fundamentowy_15cm.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Syropian fundamentowy 16 cm',
    price: 160.00,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/styropian_fundamentowy_16cm.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Syropian fundamentowy 1 cm7',
    price: 170.00,
    available_quantity: 10_000,
    product_category: foundation_zone_category,
    picture_key: 'images/products/foundation_materials/styropian_fundamentowy_17cm.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Grzebień okapowy z kratką wentylacyjną',
    price: 350.00,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/grzebien_okapowy_z_kratka_wentylacyjna.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Kratka zabezpieczająca przed ptactwem',
    price: 200.00,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/kratka_zabezpieczajaca_przed_ptactwem.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Mocownik łaty kominiarskiej',
    price: 150.00,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/mocownik_laty_kominiarskiej.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Świetlik',
    price: 100.00,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/swietlik_fakro.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Taśma kalenicowa',
    price: 55.00,
    available_quantity: 0,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/tasma_kalenicowa.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Wspornik łaty kalenicowej',
    price: 175.99,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/wspornik_laty_kalenicowej.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Wywietrznik kalenicowy',
    price: 225.99,
    available_quantity: 10_000,
    product_category: roof_zone_category,
    picture_key: 'images/products/roof_accessories/wywietrznik_kalenicowy.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Dalmierz PRO laserowy',
    price: 359.99,
    available_quantity: 10_000,
    product_category: tools_category,
    picture_key: 'images/products/tools/Dalmierz PRO laserowy.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Poziomica PRO',
    price: 220.99,
    available_quantity: 10_000,
    product_category: tools_category,
    picture_key: 'images/products/tools/Poziomica PRO.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE,
    promoted_from: PROMOTED_FROM,
    promoted_to: PROMOTED_TO
  },
  {
    name: 'Kątowniki montażowe do schodów strychowych',
    price: 799.99,
    available_quantity: 10_000,
    product_category: stairway_category,
    picture_key: 'images/products/stairway/Kątowniki montażowe do schodów strychowych.png',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Listwa wykończeniowa Fakro',
    price: 200.50,
    available_quantity: 10_000,
    product_category: stairway_category,
    picture_key: 'images/products/stairway/Listwa wykończeniowa Fakro.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Schody strychowe',
    price: 1300.00,
    available_quantity: 10_000,
    product_category: stairway_category,
    picture_key: 'images/products/stairway/Schody strychowe.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  },
  {
    name: 'Segment przesuwny',
    price: 150.00,
    available_quantity: 10_000,
    product_category: stairway_category,
    picture_key: 'images/products/stairway/Segment przesuwny.jpeg',
    picture_bucket: Rails.application.config.x.aws_bucket,
    vat_rate: VAT_RATE
  }
])
