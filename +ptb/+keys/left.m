function code = left()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'leftarrow' );
end

code = store_code;

end