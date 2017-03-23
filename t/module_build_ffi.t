use Test2::Bundle::Extended;
use Module::Build::FFI;

subtest 'ffi_dlext' => sub {

  ok(
    Module::Build::FFI->ffi_dlext,
    'true value',
  );
  
  note "ffi_dlext = @{[ Module::Build::FFI->ffi_dlext ]}";

};

subtest 'share_dir' => sub {

  my $dir = eval { Module::Build::FFI->_share_dir };
  
  skip_all 'test only with blib and actual install'
    if $@;
  
  ok -d $dir, "dir exists";
  note "dir = $dir";
  
  ok -f "$dir/include/ffi_util.h", "ffi_util exists";

};

done_testing;