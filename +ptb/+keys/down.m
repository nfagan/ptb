function code = down()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'downarrow' );
end

code = store_code;

end