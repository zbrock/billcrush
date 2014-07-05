Billcrush is a simple web app for recording shared expenses and figuring out the best way to settle. Crush your shared expenses!

## Why?
Imagine you have 2 roommates: Sally pays the rent, you pay the gas and electric bills and Frank does all the grocery shopping. It would be really nice to only exchange one check each at the end of the month to settle you debts. If you owe Frank $500 and Frank owes Sally $500, you should just pay Sally.

It's been running in private beta (a fancy way of saying I never got around to open sourcing it) since September 2010 and is tracking over $100k in shared expenses.

## Demo
Check out http://billcrush.com/demo_group

## Running your own copy
If you want to run your own instance, it should be pretty straightforward to get up and running on Heroku.

```sh
$ gem install heroku
$ heroku create
$ git push heroku master
```

There are more detailed instructions here:
http://devcenter.heroku.com/articles/quickstart

## Security
Your best bet is to run your own instance. If you want to use billcrush.com, I suggest picking a hard to guess group name. You'll access your group at `http://billcrush.com/<group_name>`, so something obscure like "a18f2887118" should act effectively like a password.


## Contributing
 * Fork
 * Fix and test
 * Send a pull request
 
## TODO List
 * Filter for showing transactions for just a given user
 * Disable a user so they don't show up in the new entry form anymore (soft delete)
 * Nicer UI to record 1-1 payments (i.e. Zach loaned brian $5)
 * Multiple members can payments