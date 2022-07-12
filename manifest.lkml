# TOC Tool
# The TOC Tool helps you set up a Table of Contents visualization that links to other dashboards and passes along the current filter states!

# For example, say you start on a dashboard like this one - it has a Table of Contents Look included (notice the current filter states).

# Before

# By clicking on any of the links in the table of contents, you’ll be taken to the corresponding dashboard with all the same filter states applied!

# After

# Here’s how you do it…

# Step 1: Specify your configurations
# Duplicate the provided config.yml file.

# This file contains a template configuration which you can replace with your own specifications.

# Here are it’s contents:

# title: payments_pacing

# dashboards:
#   - label: 'Payments Pacing Home'
#     id: 50
#   - label: 'Global Pacing by Method'
#     id: 51
#   - label: 'Global Pacing by Channel'
#     id: 52
#   - label: 'Regional Business Pacing'
#     id: 53
#   - label: 'Regional GPV Pacing'
#     id: 54

# # Types include 'number', 'date' and 'string'
# filters:
#   - label: 'Payment Create Month'
#     type: 'date'
# Things to Note:

# List your dashboards under the items section, the labels are up to you!
# You can find a dashboard’s id by looking for the first number after /dashboards/ in the dashboard’s URL.
# The specified filter label paramaters must match the label of the filters in all of the dashboards listed.
# Step 2: Generate a new table_of_contents.lkml view.
# First, ensure that you have cloned the looker git repo to your local machine, and that it is currently up to date with the master branch.

# In terminal, navigate to the GitHub/looker/toc_tool/ directory and run the following:

# python generate_table_of_contents.py --config PATH_TO_YOUR_CONFIG_FILE
# You should see a new file appear in the current directory called YOUR_TITLE_output.lkml (you can run ls in terminal to list all the files in the currrent directory).

# Making sure you’re in development mode on looker, copy and paste the contents of this file into the table_of_contents view.

# Commit your changes and submit a pull request.

# Step 3: Create a Look for your table of contents.
# In looker, open the Table of Contents Explore and enable only the dimension called YOUR_TITLE_table_of_contents. Click run and ensure that you see the names of the items you expected to see there.

# Notice that if you add any filters that you listed in your configuration file, if you click on a link, those filter values will be passed to the dashboard you clicked on!

# Click on the settings button and save as a look to your preferred directory.

# You’re now ready to add this look to any of the dashboards listed in the table of contents!

# NOTE: Make sure that when you add the look to a dashboard, you edit all the dashboard’s filters to apply to the appropriate field on the table of contents visualization.

# References
# Looker documentation on passing filters through links to dashboards
