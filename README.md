automate-hipchat-notifier
=========================

automate-hipchat-notifier is a small Sinatra app that takes notifications from
Chef Automate about failed Chef Client and Inspec runs, formats them, and sends
the result to a HipChat room.

Example Chef failure notification:
```javascript
{
  "type": "node_failure",
  "timestamp_utc": "2018-02-16T20:16:34.000000Z",
  "start_time_utc": "2018-02-16T20:16:34.000000Z",
  "node_name": "node.example.com",
  "failure_snippet": "Chef client run failure on [chef.example.com] node.example.com : https://automate.example.com/viz/#/nodes/af08c952-816b-4933-8476-9705a7a3be64?run_id=865d295d-bf67-4402-9dce-608566a8c151\n\nundefined method `contnet' for Chef::Resource::File \n",
  "exception_title": null,
  "exception_message": "undefined method `contnet' for Chef::Resource::File",
  "exception_backtrace": "/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/resource.rb:1297:in `method_missing'\n/var/chef/cache/cookbooks/test_cookbook/recipes/typo.rb:8:in `block in from_file'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/resource_builder.rb:66:in `instance_eval'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/resource_builder.rb:66:in `build'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/dsl/declare_resource.rb:293:in `build_resource'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/dsl/declare_resource.rb:250:in `declare_resource'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/dsl/resources.rb:38:in `file'\n/var/chef/cache/cookbooks/test_cookbook/recipes/typo.rb:7:in `from_file'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/mixin/from_file.rb:30:in `instance_eval'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/mixin/from_file.rb:30:in `from_file'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/cookbook_version.rb:205:in `load_recipe'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context.rb:342:in `load_recipe'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context/cookbook_compiler.rb:163:in `block in compile_recipes'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context/cookbook_compiler.rb:160:in `each'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context/cookbook_compiler.rb:160:in `compile_recipes'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context/cookbook_compiler.rb:77:in `compile'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/run_context.rb:191:in `load'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/policy_builder/expand_node_object.rb:97:in `setup_run_context'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/client.rb:513:in `setup_run_context'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/client.rb:281:in `run'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:292:in `block in fork_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:280:in `fork'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:280:in `fork_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:245:in `block in run_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/local_mode.rb:44:in `with_server_connectivity'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:233:in `run_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application/client.rb:469:in `sleep_then_run_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application/client.rb:458:in `block in interval_run_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application/client.rb:457:in `loop'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application/client.rb:457:in `interval_run_chef_client'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application/client.rb:441:in `run_application'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/lib/chef/application.rb:59:in `run'\n/opt/chef/embedded/lib/ruby/gems/2.4.0/gems/chef-13.7.16/bin/chef-client:26:in `<top (required)>'\n/usr/bin/chef-client:59:in `load'\n/usr/bin/chef-client:59:in `<main>'",
  "end_time_utc": "2018-02-16T20:16:35.000000Z",
  "automate_fqdn": "automate.example.com",
  "automate_failure_url": "https://automate.example.com/viz/#/nodes/af08c952-816b-4933-8476-9705a7a3be64?run_id=865d295d-bf67-4402-9dce-608566a8c151"
}
```

Example Compliance failure notification:
```javascript
{
  "version": "1",
  "type": "compliance_failure",
  "total_number_of_tests": 2,
  "total_number_of_skipped_tests": 0,
  "total_number_of_passed_tests": 1,
  "total_number_of_failed_tests": 1,
  "timestamp_utc": "2018-02-16T20:12:18.000000Z",
  "number_of_failed_critical_tests": 1,
  "number_of_critical_tests": 2,
  "node_uuid": "af08c952-816b-4933-8476-9705a7a3be64",
  "node_name": "node.example.com",
  "inspec_version": "1.49.2",
  "failure_snippet": "InSpec found a critical control failure on [node.example.com](https://automate.example.com/viz/#/compliance/reporting/nodes/af08c952-816b-4933-8476-9705a7a3be64)",
  "failed_critical_profiles": [
    {
      "version": "0.1.3",
      "title": "InSpec Profile",
      "supports": [

      ],
      "summary": "An InSpec Compliance Profile",
      "sha256": "7be4e5212127a8a3b5abff233bffeacc48f4ddff1575da8dfa4d110f97ed31bc",
      "number_of_controls": 1,
      "name": "linux-wrapper-example",
      "maintainer": "The Authors",
      "license": "Apache-2.0",
      "doc_version": "1",
      "copyright_email": "you@example.com",
      "copyright": "The Authors",
      "controls": [
        {
          "title": "ICMP ratelimit",
          "tags": "{}",
          "status": "failed",
          "source_location": {
            "ref": "linux-baseline-master/controls/sysctl_spec.rb",
            "line": 66
          },
          "results": [
            {
              "status": "failed",
              "run_time": 0.025758043,
              "message": "\nexpected: 100\n     got: 1000\n\n(compared using ==)\n",
              "code_desc": "Kernel Parameter net.ipv4.icmp_ratelimit value should eq 100"
            }
          ],
          "refs": "[]",
          "number_of_tests": 1,
          "number_of_failed_tests": 1,
          "impact": 1.0,
          "id": "sysctl-05",
          "desc": "icmp_ratelimit defines how many packets that match the icmp_ratemask per second",
          "code": "control 'sysctl-05' do\n  impact 1.0\n  title 'ICMP ratelimit'\n  desc 'icmp_ratelimit defines how many packets that match the icmp_ratemask per second'\n  describe kernel_parameter('net.ipv4.icmp_ratelimit') do\n    its(:value) { should eq 100 }\n  end\nend\n"
        }
      ],
      "attributes": [

      ]
    }
  ],
  "end_time_utc": "2018-02-16T20:12:18.000000Z",
  "automate_fqdn": "automate.example.com",
  "automate_failure_url": "https://automate.example.com/viz/#/compliance/reporting/nodes/af08c952-816b-4933-8476-9705a7a3be64"
}
```

Example test notification:
```javascript
{
  "username": "Chef_Automate",
  "attachments": [
    {
      "text": "Test message from Chef Automate!",
      "fallback": "Test message from Chef Automate!"
    }
  ]
}
```
