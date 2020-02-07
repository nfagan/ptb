function code = n()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'n' );
end

code = store_code;

end