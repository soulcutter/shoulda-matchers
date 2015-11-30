require 'zeus/rails'

class CustomPlan < Zeus::Plan
  def initialize
    super
    @rails_plan = Zeus::Rails.new
  end

  def boot
    ENV["BUNDLE_GEMFILE"] = File.expand_path(
      "../gemfiles/4.2.gemfile",
      __FILE__
    )

    require 'bundler/setup'

    $LOAD_PATH << File.expand_path('../lib', __FILE__)
    $LOAD_PATH << File.expand_path('../spec', __FILE__)

    require_relative 'spec/support/unit/load_environment'
  end

  def after_fork
    # @rails_plan.reconnect_activerecord
  end

  def unit_test_environment
    require_relative 'spec/unit_spec_helper'
  end

  def unit_test
    ARGV.replace(paths_to_run)
    RSpec::Core::Runner.invoke
  end

  private

  def paths_to_run
    if given_paths.empty?
      ['spec/unit']
    else
      given_paths.map { |given_path| determine_path_to_run(given_path) }
    end
  end

  def determine_path_to_run(given_path)
    candidate_path = File.expand_path(
      "../spec/unit/shoulda/matchers/#{given_path}",
      __FILE__
    )

    if File.exists?(candidate_path)
      candidate_path
    else
      given_path
    end
  end

  def given_paths
    ARGV
  end
end

Zeus.plan = CustomPlan.new
