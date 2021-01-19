# Phantom Obj - OOP for ghost
Phantom object is an library that internally creates graveyard blueprints and clone them for an "pseudo class child".

## Creating a class (blueprint)
```assembly
animate <class-name>:

  has <atribute-name>
  ...
unnerve <class-name>.
```
Internally it will be:
```assembly
graveyard <class-name> as ()

soul count as 0

dead <atribute-name> as ?count
!count as ?count pls 1
...
forget count
```

## Instantiating an object
```assembly
spawn <class>: <obj-name>
```
Internally it will be:
```assembly

graveyard <obj-name> as ()
;[graveyard[objname] = table.copy(graveyard[class])]
```

## Working with object
```assembly
main as entry
spell main[_]:

    invoke phantom

    animate obj:

        has oname
        has sound

    unnerve obj.

    spawn obj: zombie

    !zombie.?oname as 'zombie'
    !zombie.?sound as 'grr...'

    revive zombie:
    
        #talk[_]

    unnerve zombie
end.

spell talk[_]:

    tell[@it.?oname pls ' says: ' pls @it.?sound]
end

>>> zombie says: grr...
```
Within the scope of the `revive-unnerve` object, a table called `it` will be created. It works like `self` or `this` in other languages.
