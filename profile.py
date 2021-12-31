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

# Pick your OS.
imageList = [
    ('default', 'Default Image'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU18-64-STD', 'UBUNTU 18.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//UBUNTU20-64-STD', 'UBUNTU 20.04'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS7-64-STD',  'CENTOS 7'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//CENTOS8-64-STD',  'CENTOS 8'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//FBSD114-64-STD', 'FreeBSD 11.4'),
    ('urn:publicid:IDN+emulab.net+image+emulab-ops//FBSD122-64-STD', 'FreeBSD 12.2')]

pc.defineParameter("osImage", "Select OS image",
                   portal.ParameterType.IMAGE,
                   imageList[0], imageList,
                   longDescription="Most clusters have this set of images, " +
                   "pick your favorite one.")

# Optional physical type for all nodes.
pc.defineParameter("physType",  "Optional physical node type",
                   portal.ParameterType.STRING, "",
                   longDescription="Specify a physical node type (pc3000,d710,etc) " +
                   "instead of letting the resource mapper choose for you.")

# Optional ephemeral blockstore
pc.defineParameter("tempFileSystemSize", "Temporary Filesystem Size",
                   portal.ParameterType.INTEGER, 0,advanced=True,
                   longDescription="The size in GB of a temporary file system to mount on each of your " +
                   "nodes. Temporary means that they are deleted when your experiment is terminated. " +
                   "The images provided by the system have small root partitions, so use this option " +
                   "if you expect you will need more space to build your software packages or store " +
                   "temporary files.")
                   
# Instead of a size, ask for all available space. 
pc.defineParameter("tempFileSystemMax",  "Temp Filesystem Max Space",
                    portal.ParameterType.BOOLEAN, False,
                    advanced=True,
                    longDescription="Instead of specifying a size for your temporary filesystem, " +
                    "check this box to allocate all available disk space. Leave the size above as zero.")

pc.defineParameter("tempFileSystemMount", "Temporary Filesystem Mount Point",
                   portal.ParameterType.STRING,"/mydata",advanced=True,
                   longDescription="Mount the temporary file system at this mount point; in general you " +
                   "you do not need to change this, but we provide the option just in case your software " +
                   "is finicky.")

# Retrieve the values the user specifies during instantiation.
params = pc.bindParameters()

if params.tempFileSystemSize < 0 or params.tempFileSystemSize > 200:
    pc.reportError(portal.ParameterError("Please specify a size greater then zero and " +
                                         "less then 200GB", ["tempFileSystemSize"]))
pc.verifyParameters()

# Add a raw PC to the request.
node = request.RawPC("node")

# Set OS Image
if params.osImage and params.osImage != "default":
    node.disk_image = params.osImage

# Optional hardware type.
if params.physType != "":
    node.hardware_type = params.physType

# Optional Blockstore
if params.tempFileSystemSize > 0 or params.tempFileSystemMax:
    bs = node.Blockstore("node-bs", params.tempFileSystemMount)
    if params.tempFileSystemMax:
        bs.size = "0GB"
    else:
        bs.size = str(params.tempFileSystemSize) + "GB"
    bs.placement = "any"

# Install and execute a script that is contained in the repository.
node.addService(pg.Execute(shell="bash", command="/local/repository/changeShells.sh"))
node.addService(pg.Execute(shell="bash", command="/local/repository/setupAll.sh"))

# Print the RSpec to the enclosing page.
pc.printRequestRSpec(request)
