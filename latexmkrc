$pdf_mode = 4;
$lualatex = 'lualatex -synctex=1 %O %S';
$interaction = 'nonstopmode';
$halt_on_error = 1;
$file_line_error = 1;
$out_dir = $ENV{'LATEXMK_OUT_DIR'} || 'build';
$aux_dir = $out_dir;
@default_files = ('main.tex');
