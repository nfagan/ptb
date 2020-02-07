function code = p()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'p' );
end

code = store_code;

end