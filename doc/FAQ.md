Frequently Asked Questions
---

# Rules management

## I'm using default `Sonar Way` rules (with default `Sonar Way` profile). When I install one of creedengo plugins (ex : `creedengo-java plugin`), are new creedengo rules installed ? and how does the plugin do this ?

> When a creedengo plugin is installed by the marketplace, the rules are immediately available on SonarQube. You can find them if you go to "rules" tab, and select rules with tag `eco-design`. 
> 
> But by default, creedengo rules aren't set to an existing Sonarqube profile.
> 
> If you want to use creedengo rules (for one language for example), you have many ways to configure it :
> 1. Create a new quality profile, then select all rules (creedengo rules or not) that you wish to include in the new profile. Finally use this new profile as "default" profile for the selected language or set a few projects to this new quality profile.
> 2. Use our script to create the kind of profile mentioned in step 1(explanation here : https://github.com/green-code-initiative/creedengo-common/blob/main/doc/HOWTO.md#initialize-default-profiles-for-creedengo-plugins) ... WARNING : the new profile created will be set as the default profile for your language !
> 3. Update one of your current used quality profiles with new available creedengo rules.

# Testing a Creedengo plugin

## How can I test a creedengo plugin ? Do you have some sample code base to check it ?

> Yes, each Creedengo plugin has internal unit tests but also integration tests to check that all is ok.
> 
> Regarding integration test system, a test project exists to check that the plugin has an expected behaviour in real environment.
> Actually, two integration tests systems exists depending on the plugin :
> - internal integration test system : the plugin contains a test-integration directory enabling to test the plugin with Maven (`mvn verify` command).
> - external integration test system : a dedicated repository exists to test the plugin with SonarQube scanner.
>
> Here are integration test system for each existing plugin : 
> - internal integration test system
>   - `creedengo-java` plugin : sub-directory `src/it/test-projects/creedengo-java-plugin-test-project`
>   - `creedengo-python` plugin : sub-directory `src/it/test-projects/creedengo-python-plugin-test-project`
>   - `creedengo-php` plugin : sub-directory `src/it/test-projects/creedengo-php-plugin-test-project`
> - external integration test system
>   - `creedengo-javascript` plugin : sub-directory `test-project`
>   - `creedengo-csharp` plugin : https://github.com/green-code-initiative/creedengo-csharp-test-project
>   - `ecocode-android` plugin : https://github.com/green-code-initiative/ecoCode-mobile-android-test-project
>   - `creedengo-ios` plugin : https://github.com/green-code-initiative/creedengo-mobile-ios-swift-test-project
> - no integration test system yet
>   - `creedengo-html` plugin
>   - `creedengo-dashboard` plugin
>   - `creedengo-rust` plugin
>   - `creedengo-infra` plugin
>   - `creedengo-kotlin` plugin

To launch integration tests (also called end-to-end tests), please follow instructions here : https://github.com/green-code-initiative/creedengo-common/blob/main/doc/starter-pack.md#test-your-rule-implementation
> Note : for `creedengo-java`, `creedengo-python` and `creedengo-php` plugins, the integration test project is inside the plugin repository (internal integration test system)as mentionned above. For the other plugins, you need to clone the dedicated repository (external integration test system).
