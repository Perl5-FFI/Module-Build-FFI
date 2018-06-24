# Module::Build::FFI [![Build Status](https://secure.travis-ci.org/plicease/Module-Build-FFI.png)](http://travis-ci.org/plicease/Module-Build-FFI)

Build Perl extensions in C with FFI

# SYNOPSIS

In your `Build.PL`

    use Modue::Build::FFI 0.04;
    Module::Build::FFI->new(
      module_name => 'Foo::Bar',
      ...
    )->create_build_script;

or `dist.ini`:

    [ModuleBuild]
    mb_class = Module::Build::FFI
    
    [Prereqs / ConfigureRequires]
    Module::Build::FFI = 0.04

Put your .c and .h files in `ffi` (`ffi/example.c`):

    #include <ffi_util.h>
    #include <stdio.h>
    
    FFI_UTIL_EXPORT void
    print_hello(void)
    {
      printf("hello world\n");
    }

Attach it to Perl in your main module (`lib/Foo/Bar.pm`):

    package Foo::Bar;
    
    use FFI::Platypus;
    
    my $ffi = FFI::Platypus->new;
    $ffi->package;  # search for symbols in your bundled C code
    $ffi->attach( hello_world => [] => 'void');

Finally, use it from your perl script or module:

    use Foo::Bar;
    Foo::Bar::hello_world();  # prints "hello world\n"

# DESCRIPTION

Module::Build variant for writing Perl extensions in C and FFI (sans XS).

# PROPERTIES

- ffi\_source\_dir

    \[version 0.15\]

    By default, C source files in the `ffi` directory are compiled and
    linked, if that directory exists.  You can change that directory
    with this property.

    \[version 0.18\]

    This can be a scalar or a array reference.

- ffi\_libtest\_dir

    \[version 0.15\]

    If the libtest directory (`libtest` by default) exists, then C source
    files will be compiled and linked into a test dynamic library that you
    can use to test your FFI module with.  You can use FFI::CheckLib to
    find the library from your test:

        use Test::More;
        use FFI::Platypus;
        use FFI::CheckLib;
        
        FFI::Platypus->new->lib(find_lib lib => 'test', libpath => 'libtest');

    \[version 0.18\]

    This can be a scalar or a array reference.

- ffi\_include\_dir

    \[version 0.15\]

    If there is an `include` directory with your distribution with C header
    files in it, it will be included in the search path for the C files in
    both the `ffi` and `libtest` directories.

    \[version 0.18\]

    This can be a scalar or a array reference.

- ffi\_libtest\_optional

    \[version 0.15\]

    If there is no compiler then libtest cannot be built.  By default this is
    not fatal.  Your tests need to be written in such a way that any that use
    libtest are skipped when it is not there.

        use Test::More;
        use FFI::CheckLib;
        
        plan skip_all => 'test requires a compiler'
          unless find_lib lib => 'test', libpath => 'libtest';

    If you do not want to support environments without a compiler you can set
    this property to `1` and you won't need to have that check in your test
    files.

# ACTIONS

## ffi

    ./Build ffi

This builds any C files that are bundled with your distribution (usually
in the `ffi` directory).  If there is no `ffi` directory, then this
action does nothing.

This action is triggered automatically before `./Build build`.

## libtest

    ./Build libtest

This builds libtest.  If you do not have a libtest directory, then
this action does nothing.

This action is triggered automatically before `./Build test`.

# MACROS

Defined in `ffi_util.h`

- FFI\_UTIL\_VERSION

    \[version 0.04\]

    This is the [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus) (prior to version 0.15 it was the
    [FFI::Util](https://metacpan.org/pod/FFI::Util) version number) version number multiplied by 100 (so it
    would be 4 for 0.04 and 101 for 1.01).

- FFI\_UTIL\_EXPORT

    \[version 0.04\]

    The appropriate attribute needed to export functions from shared
    libraries / DLLs.  For now this is only necessary on Windows when using
    Microsoft Visual C++, but it may be necessary elsewhere in the future.

# METHODS

## ffi\_have\_compiler

\[version 0.18\]

    my $has_compiler = $mb->ffi_have_compiler;

Returns true if a C or C++ compiler is available.

Only checks for C++ if you appear to have C++ source.

Override for other foreign language subclasses.

## ffi\_build\_dynamic\_lib

\[version 0.18\]

    my $dll_path = $mb->ffi_build_dynamic_lib($src_dir, $name, $target_dir);
    my $dll_path = $mb->ffi_build_dynamic_lib($src_dir, $name);

Compiles the C and C++ source in the `$src_dir` and link it into a
dynamic library with base name of `$name.$Config{dlext}`.  If
`$target_dir` is specified then the dynamic library will be delivered
into that directory.

Override for other foreign language subclasses.

## ffi\_dlext

    my @dlext = Module::Build::FFI->ffi_dlext;

Returns a list of legal dynamic library extensions.  `$Config{dlext}` is good,
but many platforms use more than one extension for dynamic libraries.  For
example, on Mac OS X, there are two different dynamic library types `.bundle`
and `.dylib` and sometimes these renamed `.so` files.  Although `.bundle`
and `.dylib` have subtle differences, they can both be used by [FFI::Platypus](https://metacpan.org/pod/FFI::Platypus).

# AUTHOR

Graham Ollis <plicease@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2017 by Graham Ollis.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
