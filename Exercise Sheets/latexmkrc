$pdf_mode = 4;
$lualatex = 'lualatex -synctex=1 %O %S';
$interaction = 'nonstopmode';
$halt_on_error = 1;
$file_line_error = 1;
my $cache_root = $ENV{'EXERCISE_SHEETS_CACHE'} ||
  (($ENV{'LOCALAPPDATA'} || $ENV{'TMPDIR'} || '/tmp') . '/_tmp_LatexCache/mathematics_exercise_sheets');
# Builds must select an explicit cache directory through the build script.
die "Use tools/build-all.ps1 to build the exercise sheets.\n"
  unless grep { /^-outdir=/ } @ARGV;
$out2_dir = '';
$emulate_aux = 1;
# Keep SyncTeX and all other helper files in the auxiliary cache.
@out2_exts = ('pdf');
$ENV{'TEXMFVAR'} = "$cache_root/texmf";
$ENV{'TEXMFCACHE'} = $ENV{'TEXMFVAR'};
@default_files = ();
