namespace :app do
  desc "Updates all the agents by fetching them from posten"
  task update_all_agents: :environment do
    Agent.all.each do | agent |
      begin
        p "#{agent.zip} Start updating "
        SaveOrUpdateAgentForZipService.new.process(agent.zip)
        p "#{agent.zip} Successfully updated"
      rescue => e
        p "#{agent.zip} Failed"
        p e
      end
      p "-----------------------------------"
    end
  end
end
