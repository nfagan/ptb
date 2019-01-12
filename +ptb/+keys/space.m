function code = space()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'space' );
end

code = store_code;

end