use File::Path qw(make_path);
use File::Spec;

$pdf_mode = 4;
$lualatex = 'lualatex -synctex=1 %O %S';
$interaction = 'nonstopmode';
$halt_on_error = 1;
$file_line_error = 1;
$out_dir = $ENV{'LATEXMK_OUT_DIR'} || 'build';
my $local_app_data = $ENV{'LOCALAPPDATA'} || $ENV{'TEMP'} || '.';
my $default_aux_dir = File::Spec->catdir(
    $local_app_data, 'Temp', 'Mathematik1-Skript', 'latex-aux'
);
$aux_dir = $ENV{'LATEXMK_AUX_DIR'} || $default_aux_dir;
make_path($aux_dir) unless -d $aux_dir;
@default_files = ('main.tex');
