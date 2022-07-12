# Alphabetize
 Commands
This folder contains a variety of python scripts useful for Looker development.

Alphabetize View
To maintain standards across our different views, we’ve decided to list out dimensions and measures in alphabetical order. However, there’s no need to worry about doing this yourself, we’ve got a script that will fix everything for you!

Simply navigate to this directory in terminal (ensuring you’ve pulled the current version of your development branch and all your changes have been commited), and run…

python alphabetize_view.py --view NAME_OF_VIEW

You’ll now see a new view file saved to this directory called output_NAME_OF_VIEW.view.lkml.

Copy and paste the contents of this file into the corresponding view in the looker front-end development environment, commit these final changes and open a pull request. You’re good to go now!
