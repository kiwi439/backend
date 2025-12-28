require 'rails_helper'

describe Services::Monitoring::BuildMonitoringPayloadService, type: :service do
  describe '#call' do
    subject { described_class.call(params: params) }

    let(:params) do
      {
        cpu_usage: 'us:10 sy:5',
        mem_info: 'total:16000 used:8000 free:8000',
        swap_info: 'total:2000 used:500 free:1500',
        logged_users: 'alice bob',
        recent_actions: 'deploy restart',
        public_ip: " 1.2.3.4\n",
        private_ip: " 10.0.0.1 \n"
      }
    end

    it 'builds payload with parsed values' do
      expect(subject).to eq({
        total_memory: '16000',
        used_memory: '8000',
        free_memory: '8000',
        swap_total_memory: '2000',
        swap_used_memory: '500',
        swap_free_memory: '1500',
        user_cpu_time: '10',
        system_cpu_time: '5',
        logged_users: %w[alice bob],
        recent_actions: %w[deploy restart],
        public_ip: '1.2.3.4',
        private_ip: '10.0.0.1'
      })
    end

    context 'when params are invalid' do
      let(:params) { {} }

      it 'raises BuildMonitorResourcePayloadError' do
        expect { subject }.to raise_error(Services::Monitoring::BuildMonitoringPayloadService::BuildMonitorResourcePayloadError)
      end
    end
  end
end


