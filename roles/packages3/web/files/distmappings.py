# Global list of koji tags we care about
tags = ({'name': 'Rawhide', 'tag': 'f41'},

        {'name': 'Fedora 40', 'tag': 'f40-updates'},
        {'name': 'Fedora 40', 'tag': 'f40'},
        {'name': 'Fedora 40 Testing', 'tag': 'f40-updates-testing'},
        
        {'name': 'Fedora 39', 'tag': 'f39-updates'},
        {'name': 'Fedora 39', 'tag': 'f39'},
        {'name': 'Fedora 39 Testing', 'tag': 'f39-updates-testing'},
        
        {'name': 'Fedora 38', 'tag': 'f38-updates'},
        {'name': 'Fedora 38', 'tag': 'f38'},
        {'name': 'Fedora 38 Testing', 'tag': 'f38-updates-testing'},

        {'name': 'Fedora 37', 'tag': 'f37-updates'},
        {'name': 'Fedora 37', 'tag': 'f37'},
        {'name': 'Fedora 37 Testing', 'tag': 'f37-updates-testing'},

        {'name': 'Fedora 36', 'tag': 'f36-updates'},
        {'name': 'Fedora 36', 'tag': 'f36'},
        {'name': 'Fedora 36 Testing', 'tag': 'f36-updates-testing'},

        {'name': 'Fedora 35', 'tag': 'f35-updates'},
        {'name': 'Fedora 35', 'tag': 'f35'},
        {'name': 'Fedora 35 Testing', 'tag': 'f35-updates-testing'},

        {'name': 'Fedora 34', 'tag': 'f34-updates'},
        {'name': 'Fedora 34', 'tag': 'f34'},
        {'name': 'Fedora 34 Testing', 'tag': 'f34-updates-testing'},


        {'name': 'Fedora 33', 'tag': 'f33-updates'},
        {'name': 'Fedora 33', 'tag': 'f33'},
        {'name': 'Fedora 33 Testing', 'tag': 'f33-updates-testing'},


        {'name': 'Fedora 32', 'tag': 'f32-updates'},
        {'name': 'Fedora 32', 'tag': 'f32'},
        {'name': 'Fedora 32 Testing', 'tag': 'f32-updates-testing'},

        {'name': 'Fedora 31', 'tag': 'f31-updates'},
        {'name': 'Fedora 31', 'tag': 'f31'},
        {'name': 'Fedora 31 Testing', 'tag': 'f31-updates-testing'},

        {'name': 'Fedora 30', 'tag': 'f30-updates'},
        {'name': 'Fedora 30', 'tag': 'f30'},
        {'name': 'Fedora 30 Testing', 'tag': 'f30-updates-testing'},

        {'name': 'Fedora 29', 'tag': 'f29-updates'},
        {'name': 'Fedora 29', 'tag': 'f29'},
        {'name': 'Fedora 29 Testing', 'tag': 'f29-updates-testing'},

        {'name': 'Fedora 28', 'tag': 'f28-updates'},
        {'name': 'Fedora 28', 'tag': 'f28'},
        {'name': 'Fedora 28 Testing', 'tag': 'f28-updates-testing'},

        {'name': 'Fedora 27', 'tag': 'f27-updates'},
        {'name': 'Fedora 27', 'tag': 'f27'},
        {'name': 'Fedora 27 Testing', 'tag': 'f27-updates-testing'},

        {'name': 'Fedora 26', 'tag': 'f26-updates'},
        {'name': 'Fedora 26', 'tag': 'f26'},
        {'name': 'Fedora 26 Testing', 'tag': 'f26-updates-testing'},

        {'name': 'Fedora 25', 'tag': 'f25:updates'},
        {'name': 'Fedora 25', 'tag': 'f25'},
        {'name': 'Fedora 25 Testing', 'tag': 'f25-updates-testing'},

        {'name': 'EPEL 8', 'tag': 'epel8'},
        {'name': 'EPEL 8 Testing', 'tag': 'epel8-testing'},
        {'name': 'EPEL 8 Staging', 'tag': 'epel8-staging'},

       )

tags_to_name_map = {}
for t in tags:
    tags_to_name_map[t['tag']] = t['name']
