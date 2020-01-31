function code = r()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'r' );
end

code = store_code;

end