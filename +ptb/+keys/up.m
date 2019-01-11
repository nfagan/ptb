function code = up()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'uparrow' );
end

code = store_code;

end