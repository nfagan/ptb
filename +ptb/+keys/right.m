function code = right()

persistent store_code;

if ( isempty(store_code) )
  store_code = KbName( 'rightarrow' );
end

code = store_code;

end