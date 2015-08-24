# Some resources...

* Customizing Your Shell: http://www.dsl.org/cookbook/cookbook_5.html#SEC69
* Consistent BackSpace and Delete Configuration: http://www.ibb.net/~anne/keyboard.html
* The Linux Documentation Project: http://www.tldp.org/
* The Linux Cookbook: http://www.tldp.org/LDP/linuxcookbook/html/
* Greg's Wiki http://mywiki.wooledge.org/

# Setup some default paths. 
Note that this order will allow user installed software to override 'system' software. Modifying these default path settings can be done in different ways. To learn more about startup files, refer to your shell's man page. 

## If you wish to change the path for all users, it is recommended you edit
*    /etc/zshenv # runs before /etc/zprofile
* or /etc/zshrc  # runs after /etc/zprofile (for interactive shells)
* or /etc/zlogin # runs after /etc/zprofile (for login shells)

## If you wish to change the path on a user by user basis, it is recommended you edit
*    ~/.zshenv   # runs before ~/.zprofile
* or ~/.zprofile # (for login shells)
* or ~/.zshrc    # runs after ~/.zprofile (for interactive shells)
* or ~/.zlogin   # runs after ~/.zprofile (for login shells)