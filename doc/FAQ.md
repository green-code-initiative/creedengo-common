Frequently Asked Questions
---

## I'm using default `Sonar Way` rules (with default `Sonar Way` profile). When I install one of creedengo plugins (ex : `creedengo-java plugin`), are new creedengo rules installed ? and how does the plugin do this ?

> When a creedengo plugin is installed by the marketplace, the rules are immediately available on SonarQube. You can find them if you go to "rules" tab, and select rules with tag `eco-design`. 
> 
> But by default, creedengo rules aren't set to an existing Sonarqube profile.
> 
> If you want to use creedengo rules (for one language for example), you have many ways to configure it :
> 1. Create a new quality profile, then select all rules (creedengo rules or not) that you wish to include in the new profile. Finally use this new profile as "default" profile for the selected language or set a few projects to this new quality profile.
> 2. Use our script to create the kind of profile mentioned in step 1(explanation here : https://github.com/green-code-initiative/creedengo-common/blob/main/doc/HOWTO.md#initialize-default-profiles-for-creedengo-plugins) ... WARNING : the new profile created will be set as the default profile for your language !
> 3. Update one of your current used quality profiles with new available creedengo rules.