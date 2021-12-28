"""
Setup script for deploying train-ticket on CloudLab
"""

# Import the Portal object.
import geni.portal as portal
# Import the ProtoGENI library.
import geni.rspec.pg as pg

# Create a portal context.
pc = portal.Context()

# Create a Request object to start building the RSpec.
request = pc.makeRequestRSpec()
 
# Add a raw PC to the request.
node = request.RawPC("node")

# Check if this script is even running
with open('/tmp/profile_test.txt', 'x') as outfile:
	outfile.write("testing profile.py\n")

# Install and execute a script that is contained in the repository.
node.addService(pg.Execute(shell="bash", command="/local/repository/changeShells.sh"))
#node.addService(pg.Execute(shell="bash", command="/local/repository/dockerSetup.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
