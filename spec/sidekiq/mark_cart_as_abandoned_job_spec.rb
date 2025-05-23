require 'rails_helper'

RSpec.describe MarkCartAsAbandonedJob, type: :job do
  let(:service_instance) { instance_double(CartAbandonmentService) }

  it 'calls CartAbandonmentService#perform' do
    expect(CartAbandonmentService).to receive(:new).and_return(service_instance)
    expect(service_instance).to receive(:perform)

    described_class.perform_now
  end
end