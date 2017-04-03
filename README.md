# ColdFusion Wunderlist API

---

This is a ColdFusion Wrapper written to interact with the Wunderlist API.


## Authors

Developed by Matt Gifford (aka coldfumonkeh)

- http://www.mattgifford.co.uk
- http://www.monkehworks.com


### Share the love

Got a lot out of this package? Saved you time and money?

Share the love and visit Matt's wishlist: http://www.amazon.co.uk/wishlist/B9PFNDZNH4PY

---

## Requirements


The package has been tested against:

* Lucee 4.5
* Lucee 5

# CommandBox Compatible

## Installation
This CF wrapper can be installed as standalone or as a ColdBox Module. Either approach requires a simple CommandBox command:

`box install wunderlist`

Then follow either the standalone or module instructions below.

### Standalone
This wrapper will be installed into a directory called `wunderlist` and then can be instantiated via `new wunderlist.wunderlist()` with the following constructor arguments:

```
     clientId    	=	'',
     clientSecret   =	'',
     accessToken	=	''
```

### ColdBox Module
This package also is a ColdBox module as well. The module can be configured by creating a `wunderlist configuration structure in your application configuration file: config/Coldbox.cfc with the following settings:

```
wunderlist = {
     clientId    	=	'',
     clientSecret   =	'',
     accessToken	=	''
};
```
Then you can leverage the CFC via the injection DSL: `wunderlist@wunderlist`

## Useful Links

Please visit the official documentation for details on the methods available:

https://developer.wunderlist.com/documentation/
