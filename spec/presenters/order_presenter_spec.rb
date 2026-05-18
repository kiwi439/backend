describe OrderPresenter do
  describe '#company_details' do
    subject { described_class.new(order).company_details }

    let(:order) { create(:order) }

    it 'returns company details array' do
      expect(subject).to eq([
        { field: 'Adres:', value: 'Żywiec, 34-300, Beskidzka 50' },
        { field: 'Telefon:', value: '724 131 140' },
        { field: 'Adres email:', value: 'siwiec.michal724@gmail.com' }
      ])
    end
  end

  describe '#bill_to_details' do
    subject { described_class.new(order).bill_to_details }

    let(:user) { create(:user, email: 'customer@example.com') }
    let(:order) { create(:order, user: user, name: 'John', surname: 'Doe', phone_number: '123456789') }

    it 'returns bill to details array' do
      expect(subject).to eq([
        { field: 'Nabywca:', value: 'John Doe' },
        { field: 'Telefon:', value: '123456789' },
        { field: 'Adres email:', value: 'customer@example.com' }
      ])
    end
  end

  describe '#ship_to_details' do
    subject { described_class.new(order).ship_to_details }

    let(:order) { create(:order, city: 'Warsaw', postal_code: '00-001', street: 'Main Street') }

    it 'returns ship to details array' do
      expect(subject).to eq([
        { field: 'Miasto', value: 'Warsaw' },
        { field: 'Kod pocztowy:', value: '00-001' },
        { field: 'Ulica:', value: 'Main Street' },
        { field: 'Numer mieszkania:', value: '22' }
      ])
    end
  end

  describe '#rows_names' do
    subject { described_class.new(order).rows_names }

    let(:order) { create(:order) }

    it 'returns product rows names array' do
      expect(subject).to eq(['Nazwa produktu', 'Kategoria', 'Ilość', 'Cena'])
    end
  end

  describe '#products_details' do
    subject { described_class.new(order).products_details }

    let(:user) { create(:user, email: 'test@example.com') }
    let(:category) { create(:product_category, name: 'stairway') }
    let(:product1) { create(:product, product_category: category, name: 'Product 1', price: 100.0) }
    let(:product2) { create(:product, product_category: category, name: 'Product 2', price: 200.0) }
    let(:order) { create(:order, user: user) }

    before do
      create(:products_order, order: order, product: product1, product_quantity: 2)
      create(:products_order, order: order, product: product2, product_quantity: 1)
    end

    it 'returns products details array' do
      expect(subject).to eq([
        {
          name: 'Product 1',
          category_name: 'Schody',
          quantity: 2,
          price: 100.0
        },
        {
          name: 'Product 2',
          category_name: 'Schody',
          quantity: 1,
          price: 200.0
        }
      ])
    end
  end

  describe '#total_price' do
    subject { described_class.new(order).total_price }

    let(:user) { create(:user, email: 'test@example.com') }
    let(:product) { create(:product, price: 50.0) }
    let(:order) { create(:order, user: user, delivery_method: 'in_post') }

    before do
      create(:products_order, order: order, product: product, product_quantity: 2)
    end

    it 'returns total price calculated by service' do
      expect(subject).to eq(110.99)
    end
  end
end
