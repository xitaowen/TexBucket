TexBucket
=========

An innovative way to collaborate on a Latex doc and sync with a web portal


Prerequisite
--------------------
Linux OS (Ubuntu 14.04 and Fedora 19 tested)
httpd (Apache 2.2.22 and 2.4.9 tested)
texlive
subversion

Installation
--------------------
1. Clone the git repo to the deployment directory.
2. Run "sudo ./setup" and type in httpd document root if necessary.

Usage
--------------------
1. If you want to add a repo, run
'''
sudo texbucket_new repo_name
'''

Next, you need to add system accounts who are allowed to edit the repo by issuing
'''
sudo texbucket_useradd username repo_name
'''

The repo will be then accessable via svn+ssh://server_address/repo/name_of_your_repo, and the web portal is at http://server_address/texbucket/repo_name/index.html

2. To revoke the access of a system account, run
'''
sudo textbucket_userdel username repo_name
'''

3. To remove a repo permanently, run
'''
sudo textbucket_remove repo_name
'''
