# Code Style Guide - Creedengo

- [Code Style Guide - Creedengo](#code-style-guide---creedengo)
	- [Introduction](#introduction)
	- [Source File Basics](#source-file-basics)
		- [File encoding: UTF-8](#file-encoding-utf-8)
		- [Indentation](#indentation)
	- [Formatting](#formatting)
	- [Java Programming Practices](#programming-practices)
		- [Naming](#naming)
			- [Constant names](#constant-names)
			- [Variable names](#variable-names)
		- [Java source file organization](#java-source-file-organization)
		- [Class declaration](#class-declaration)
		- [File history](#file-history)
		- [Organization of setter methods](#organization-of-setter-methods)
		- [Ternary Operator](#ternary-operator)
		- [Null Checks](#null-checks)
		- [Use of @Override](#use-of-override)
		- [Utility classes](#utility-classes)
		- [Field and method references](#field-and-method-references)
		- [Local variable type inference](#local-variable-type-inference)
		- [Some rules from experience](#some-rules-from-experience)
			- [Protections against ClassCast exceptions](#protections-against-classcast-exceptions)
	- [Javadoc](#javadoc)
		- [Javadoc formatting](#javadoc-formatting)
	- [Tests](#tests)
		- [Testing Framework](#testing-framework)
		- [Naming](#naming-1)
		- [Assertions](#assertions)
		- [Mocking](#mocking)
		- [Some rules from experience](#some-rules-from-experience-1)
			- [Unit tests](#unit-tests)

## Introduction

This document defines the coding standards for source and configuration files.

## File Basics

### File encoding: UTF-8

Files must be encoded using `UTF-8`.

### Indentation

2 spaces.

## Formatting

Formatting must be checked in build using [Spotless Maven plugin](https://github.com/diffplug/spotless/tree/main/plugin-maven) with configuration depending on file type:

- Java - [Google Java Format](https://github.com/google/google-java-format) based on [Google Java Style](https://google.github.io/styleguide/javaguide.html)
- POM - [sortPom](https://github.com/Ekryd/sortpom)
- JSON - [Eclipse WTP](https://github.com/diffplug/spotless/tree/main/plugin-maven#eclipse-web-tools-platform)

See [creedengo-rules-specifications pom.xml](https://github.com/green-code-initiative/creedengo-rules-specifications/blob/main/pom.xml) for the Spotless configuration reference.

## Java Programming Practices

### Naming

#### Constant names

Constant names use `CONSTANT_CASE`: all uppercase letters, with words separated by underscores.

Every constant is a `static final` field, but not all `static final` fields are constants. Constant case should therefore be chosen only if the field **is really** a constant.

Example:

```java
// Constants
private static final Object NULL_HOLDER = new NullHolder();
public static final int DEFAULT_PORT = -1;

// Not constants
private static final ThreadLocal<Executor> executorHolder = new ThreadLocal<Executor>();
private static final Set<String> internalAnnotationAttributes = new HashSet<String>();
```

#### Variable names

Avoid using single characters as variable names. For instance prefer `Method method` to `Method m`.

### Java source file organization

The following governs how the elements of a source file are organized:

1. static fields
1. normal fields
1. constructors
1. (private) methods called from constructors
1. static factory methods
1. getters and setters
1. method implementations coming from interfaces
1. private or protected templates that get called from method implementations coming from interfaces
1. other methods
1. `equals`, `hashCode`, and `toString`

Note that private or protected methods called from method implementations should be placed immediately below the methods where they're used. In other words if there 3 interface method implementations with 3 private methods (one used from each), then the order of methods should include 1 interface and 1 private method in sequence, not 3 interface and then 3 private methods at the bottom.

Above all, the organization of the code should feel _natural_.

### Class declaration

Order the classes in _implements_ so that the most important comes first.

### File history

- A file should look like it was crafted by a single author, not like a history of changes
- Don't artificially spread things out that belong together

### Organization of setter methods

Choose wisely where to add a new setter method; it should not be simply added at the end of the list. Perhaps the setter is related to another setter or relates to a group. In that case it should be placed near related methods.

- Setter order should reflect order of importance, not historical order
- Ordering of _fields_ and _setters_ should be **consistent**

### Ternary Operator

Make sure that the _not null_ condition comes first.

### Use of @Override

Always add `@Override` on methods overriding or implementing a method declared in a super type.

### Utility classes

A class that is only a collection of static utility methods must be named with a `Utils` suffix, must have a `private` default constructor, and must be `abstract`. Making the class `abstract` and providing a `private` _default_ constructor prevent anyone from instantiating it. For example:

```java
public abstract MyUtils {

    private MyUtils() {
        /* prevent instantiation */
    }

    // static utility methods
}
```

### Field and method references

A field of a class should *always* be referenced using `this`. A method of class, however, should never be referenced using `this`.

### Local variable type inference

The use of `var` for variable declarations (_local variable type inference_) is not permitted. Instead, declare variables using the concrete type or interface (where applicable).

### Some rules from experience

#### Protections against ClassCast exceptions

From experience with issue [#42](https://github.com/green-code-initiative/creedengo-rules-specifications/issues/42), when an exception occurs during Sonar analysis with maven command, the consequence is a crash. If this phase is launched in a CI/CD pipeline, this crash will block the pipeline. Thus, our plugins will be deleted until next corrections.

Please, make a maximum of controls in the code to avoid ClassCast exceptions and thus, avoid uninstalling our plugin from SonarQube.

## Javadoc

### Javadoc formatting

The following template summarizes a typical use for the Javadoc of a method.

```java
/**
 * Parse the specified {@link Element} and register the resulting
 * {@link BeanDefinition BeanDefinition(s)}.
 * <p>Implementations must return the primary {@link BeanDefinition} that results
 * from the parsing if they will ever be used in a nested fashion (for example as
 * an inner tag in a {@code <property/>} tag). Implementations may return
 * {@code null} if they will <strong>not</strong> be used in a nested fashion.
 * @param element the element that is to be parsed into one or more {@link BeanDefinition BeanDefinitions}
 * @param parserContext the object encapsulating the current state of the parsing process;
 * provides access to a {@link org.springframework.beans.factory.support.BeanDefinitionRegistry}
 * @return the primary {@link BeanDefinition}
 */
BeanDefinition parse(Element element, ParserContext parserContext);
```

In particular, please note:

- Use an imperative style (i.e. _Return_ and not _Returns_) for the first sentence.
- No blank lines between the description and the parameter descriptions.
- If the description is defined with multiple paragraphs, start each of them with `<p>`.
- If a parameter description needs to be wrapped, do not indent subsequent lines (see `parserContext`).

The Javadoc of a class has some extra rules that are illustrated by the sample below:

```java
/*
 * Interface used by the {@link DefaultBeanDefinitionDocumentReader} to handle custom,
 * top-level (directly under {@code <beans/>}) tags.
 *
 * <p>Implementations are free to turn the metadata in the custom tag into as many
 * {@link BeanDefinition BeanDefinitions} as required.
 *
 * <p>The parser locates a {@link BeanDefinitionParser} from the associated
 * {@link NamespaceHandler} for the namespace in which the custom tag resides.
 *
 * @author Rob Harrop
 * @since 2.0
 * @see NamespaceHandler
 * @see AbstractBeanDefinitionParser
 */
```

- The order of tags for class-level Javadoc is: `@author`, `@since`, `@param`, `@see`, `@deprecated`.
- The order of tags for method-level Javadoc is: `@param`, `@return`, `@throws`, `@since`, `@see`, `@deprecated`.
- In contrast to method-level Javadoc, the paragraphs of a class description *are* separated by blank lines.

The following are additional general rules to apply when writing Javadoc:

- Use `{@code}` to wrap code statements or values such as `null`.
- If a type is only referenced by a `{@link}` element, use the fully qualified name in order to avoid an unnecessary `import` declaration.

## Tests

### Testing Framework

Tests must be written using JUnit Jupiter (a.k.a., JUnit 5).

### Naming

Each test class name must end with a `Tests` suffix.

### Assertions

Use AssertJ for assertions.

### Mocking

Use the BDD Mockito support.

### Some rules from experience

#### Unit tests

Unit test are mandatory. If you can, use Test Driven Development method to write your tests.
Check coverage of your tests with SoanrQube integration of our code.