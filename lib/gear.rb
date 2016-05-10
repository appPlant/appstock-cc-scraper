require 'timeout'

# Extracted logic from the Scraper class to isolate its "gear" logic.
module Gear
  # Slice the list of ISINs into smaller chunks and create multiple forks
  # to scrape them.
  #
  # @param [ Array<String> ] isins List of ISIN numbers.
  # @param [ Array<Symbol> ] fields: Subset of Scraper::FIELDS.
  # @param [ Int ] concurrent Max number of concurrent requests.
  # @param [ Int ] parallel: Max number of stocks per request.
  #
  # @return [ Array<Int>, IO, IO ] List of pids and IO pipes.
  def run_gear(isins, fields, concurrent, parallel)
    forks  = []
    rd, wr = IO.pipe

    isins.each_slice(concurrent) do |subset|
      if fields.include? :ScreenerAnalysisV1
        wr.puts run_hydra(subset, parallel, fields)
      else
        forks << fork { wr.puts run_hydra(subset, parallel, fields) }
      end
    end

    [forks, rd, wr]
  end

  protected

  # Run the hydra for the given set of ISINs.
  #
  # @param [ Array<String> ] isins List of ISIN numbers.
  # @param [ Int ] per_request: Max number of stocks per request.
  # @param [ Array<Symbol> ] fields: Subset of Scraper::FIELDS.
  #
  # @return [ Int ] Number of scraped stocks.
  def run_hydra(isins, per_request, fields)
    isins.each_slice(per_request) { |stocks| scrape stocks, fields: fields }

    @count = 0
    @hydra.run

    @count
  end

  # Sum the numbers included in the provided pipes and close them.
  #
  # @param [ IO ] rd Pipe to read the content.
  # @param [ IO ] wr Pipe to write in the content.
  #
  # @return [ Void ]
  def sum_scraped_stocks(rd, wr)
    wr.close
    rd.read.split.map!(&:to_i).reduce(&:+)
  ensure
    rd.close
  end

  # Wait for finished execution of all forks, but not more then the specified
  # timeout in seconds in total.
  #
  # @param [ Array<Int> ] forks List of process pids.
  # @param [ Int ] timeout: Total time in seconds to wait for.
  #
  # @return [ Void ]
  def wait_for(forks, timeout: 20)
    Timeout.timeout(timeout) { Process.waitall }
  rescue Timeout::Error
    puts 'timeout'
    kill_forks(forks)
  end

  # Kill all forked child processes and wait for their exit to avoid zombies.
  #
  # @param [ Array<Int> ] pids Process PID numbers to kill.
  #
  # @return [ Void ]
  def kill_forks(pids)
    pids.each do |pid|
      begin
        Process.kill('INT', pid)
        Process.wait(pid)
      rescue Errno::ESRCH, Errno::ECHILD
        nil
      end
    end
  end
end
