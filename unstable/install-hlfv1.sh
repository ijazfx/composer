ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1.sh | bash"
  exit 1
fi
(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -e

# Docker stop function
function stop()
{
P1=$(docker ps -q)
if [ "${P1}" != "" ]; then
  echo "Killing all running containers"  &2> /dev/null
  docker kill ${P1}
fi

P2=$(docker ps -aq)
if [ "${P2}" != "" ]; then
  echo "Removing all containers"  &2> /dev/null
  docker rm ${P2} -f
fi
}

if [ "$1" == "stop" ]; then
 echo "Stopping all Docker containers" >&2
 stop
 exit 0
fi

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# stop all the docker containers
stop



# run the fabric-dev-scripts to get a running fabric
./fabric-dev-servers/downloadFabric.sh
./fabric-dev-servers/startFabric.sh
./fabric-dev-servers/createComposerProfile.sh

# pull and tage the correct image for the installer
docker pull hyperledger/composer-playground:0.8.0
docker tag hyperledger/composer-playground:0.8.0 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.hfc-key-store
tar -cv * | docker exec -i composer tar x -C /home/composer/.hfc-key-store

# Wait for playground to start
sleep 5

# Kill and remove any running Docker containers.
##docker-compose -p composer kill
##docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
##docker ps -aq | xargs docker rm -f

# Open the playground in a web browser.
case "$(uname)" in
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

echo
echo "--------------------------------------------------------------------------------------"
echo "Hyperledger Fabric and Hyperledger Composer installed, and Composer Playground launched"
echo "Please use 'composer.sh' to re-start, and 'composer.sh stop' to shutdown all the Fabric and Composer docker images"

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� -sJY �=M��Hv��dw���A'@�9����������IQ����4��*I�(RMR�Ԇ�9$��K~A.An{\9�Kr�=�C.9� �")�>[�a�=c=ÖT����{�^�WU,��͠bt{��=M5M���C����� � ��O:�Rӟ�C?��4�DbK1(:��" ���_	}˖M ئ<P��x���0����x�<&�U��A ��	s}ǿt[Vuh��r�Mj�J�+7QYkԃ��Mh����!��Ӷ�.��q*N���eP���w�n����T,T��P�'3�=�_���7 uؐ��-�=T�4�{ ��r�T��7�-�yT�N�	�Z�נ:,����<Y���0	���H�M��Q��l���<��;pt(k�0],�et�D�d��P�%h����]h�m�2LQ��Y�&���\ݼ�g��M��4{�I����P��4B��a�,i�f���OJKF�r���?��V/��8�IK��"�"c5�Ym�v����\F�\*w�:�f�����Lxއ�}P�M	�D���<G�c`� [�n?�kɟXU�f�|LXG�UY���\���6�/T*bbQY����s��".���v���#x�mh�6v+�n���%޷C�0xJ
�� ��?��[��'�X�]5�c��t�Ext�fc ��9Y���D�6�ͺ�蜦%��0d��D��?�R�E����(�� ��?TB���o��K���dM�Z��\%}���ݒm�Q5�z��k *���뺪7/�B��4BAG��S�5A��GO��=ϟj��G���� �r��sܥ��2TZd=ܷ��.�	 ��- р%���a/�Qp�t{&*"�����3+���C��_���n� ��t�`)&'4���F��-�@��Db�+��%�>6�̯ge��y��UL���)�����>�g�S��	COt�md6`I4�ǉ�O�O~�4��s��е�+�)����Y���.��K3�:�����.��+�U�m�y����n!Ay8D��5([XPC)pZ�����oA��Z�O�
���a��:_�L,��;�@ձ��^~��M�9b�˪0�G.�$��'��5�� �L(w�?�D��<A�D�|���C��ˡ%+D����lÒ�"Ϝ�:���f��P����a��0T�����v��L����7�|���ݏ�j�4	�/�U
eA|I!��W_��SG��3���Hq�F~P����3�[�7��J ���	����W��������#�������i��`���ij>��E���o޾����-:!�.Pu�M�`τu����P����׹;,�ń�ǫx���]<�����m����v���a��_��-�Xc���c��?���7�I�f��+og�;���wy��m�c���� e�5o��o���5�b戸m$PMg*g��)V��G�	�ͨ����N��|����ǘ%w�,x�Nr|9#���J��6|s�e�ox�  �}݂�7@��~�N`!�!>�f����Ypu��G����lb�T.�[�r��Y5#����j�gЖ�N�������ӅG�i�O��3�=!�?��Tp�ճG�<�����K�h)����G&�^��v������=�7l �߭A3 ���y�nI��2Y���A��:�}�i����E�g[����uw7?��b����&`��]w�Q�.�����	��?Mm�m����l
��$�������&`����gaCGs�i� ��a~z���:�@T�+�h"D�8W��/�[G���J�o��{\"�G��Sj]�ٲAm��a��c!¥����3/��`c����oĸ'l~L��u��.����?����p8�����S������@[n��k���:��w�/D��|����#����7�GϢ� �BT�my]+E�Eꃛ7�_��=����%���u��.����(*�h���������u�>^��5�Ȳa`�`]{�_2�����B�|a&��'k�"�� y)��A�~N�&�A^�l��oz��a��3/�_OQPZ�����p�0}�{��q�wb�ͱ�T����)���M��������16:��������S���ܑ�6ks��-��{ X�����dGd>��ZBCn��F����'o2� ֜��䉭>�re��4�Ĕ���o����[oK����q'���������q%B��BY<+�b�,W��T)f��W��0P��V~����Ih+�thڵzd��N�}����W�`���n�A�H A�z�0y1kv�4�6Ԧ=$'h!{����P�UL �N�)t����]�"TCQI�R(D�BK�����������|��������������k��
�FV��B�hvN����/�W����O?��'���o��_7��D�_Gǡ��u�U`�Rv!��dX��Y&&G�
7bt�+Y����E)%�J��G��@��M{�O�^���æ/��~���ϿH��'��������c�?&.��v�?�z=MUd�-�|��3�ȭ2ȇ�<���/P� ��&O��������/K��Ǐv���.��~4�����O\/l�|���~�C��1��鑩�9���Ý�G��M
p]�3Su~��~�ax'HL�V��������?�����o>��o��I�ׁ�/�i�3Km��7���[�����!������tx~���b[�����	��<f����R���N�q�+pg�$.�C�N�A��aE,�;���<����v�MS|��w������������4��QI#^�Y�+�[�@��Ԃ��Pv�;pt��d��ˍ0�1�\cc���0��h��(�A�cZ��Z��e�F���#�8���|fupd�^���_����ҭ����pJV!R1G=�S�Q&򏲮^��Zx>R�ɽ�>���f5�p�E�K�.A\3\W�����rB,���b�ˡ�?���~����h�JU�s�DY�T����g%6��d*�XM�x��CMfrKh��؎�Te��P��j�	��g��c\	�k�q��4���v�/eB	�Y]5� i�l�i�d�EZ�B6U�կ��hQY3�L�v�p��qF覅��7���Xb3h�V���5�i_�����%$�Etk�so [q��
�~��M	3Wf�O���➲�6�w�����[i�n�~(���D���W���:�#I�eX69�M���~��-�2�G�s�\�>R�|�m3�B�z!�e�B!q��y������]\�X�t�U�;���؃]qG���!���M��^���m��xF���2�/���y,��~�g���_����a7��/򳐚�b���wN�T�o�X T�(Y�x�B���,/V�
嬄d��p=ܬ�D
��T�������U�}��&�+���N�>Q��X���\v7����u��z��e?opI�<W3��=ͼԱ�ӚvK��\��h�fm�8��u��w�VM��f~�����
�'�\ĸ��z#a�%�n��|�ɀ%:�#�r�-�	�제����'V�ۈ�B�J}�x"��? �q�?k6עq��������M����6�и�������&��aڼ���a*���& D���r��̩z�јZ�uu=�Iё��X��P�� �������Mð��[W��wo�8>~�O��U�	����G#[����?�,�f��7�����{����[�������3=���Xt��7���ϷN�G�oy|h�)���/��/�{�k#����Lb��If�*�����ٶ p�T�s2<�̔2��hzp��(���I��b������V�](�J	��;R�r�t�8,�R�����B�J�G�/eKLҒ�NJ��T�#�/�u�P�0�~F<'Gl[>ηk��+^�T��_�R��`*i+�������%7�p�E$&j���(��Jmn���ʨl�q�2)i	�{�7�<wR�êT��{����'G��iwwT�j-�|�$9�.-:t��(�$���V���)L~ ��N�k�H��i���:<��2�u#'G�SK�O�][Jv�9IY�4sѦ�t��'���(591��Wj��?�յT�q�+��� �s�,�ĳ�c�HF����1�:
��b���ű~�[탃^��P��U�\w���DqZ��WJ�<���<jJ��%\Q*Ig��Jq��$�8/q�[':"O:%A�8'�$�K�JN������G��9+Q��>fj�A�8.fA�Wr�ʝJ������@�,��(;�S�2͚x�5�f�RJQz]=�ի�T6�%�X�ӈ'NTmW9��(J�$�*qP.{9x��z�������v\>���Aꂊ���b>�h��R�܇���.�Q����������6������?���>��^X�����M��m���>��,^���m��	X��W(���q�_�z�W�0�ִ�V�ލ�?�(�T���%!���x9}K��x���d�Y:�V-�uQ�ޗ��a��xuJ5q��T>E(]��1��	��ܱ�`T�����B��Z�c�:���CM�H.��I���TU�|"3��Gj0G���9��6�x�.�^Ǹ�2��?ř8?:OU��.�Q&�w�4Ge8>���m]SM%�B����7��^"Yn:�n����#�J��ص�[�V�1��mI;~T�M1Ww�B�*Z��T�=�|ޖ��.q7�Ox�>�9�ks�X��ʁ(���,���7�&��|I��.RY�F\�\/0HB��YRyAPsr��G��!�;'�����B����V4��j�H�����r{n����p	>ɩ"g�s'�	S#��N��p0l�^f�U��x��ws�U-'�/��(d�=T���i��U`��86L�#EEҼq��|��cY(�������m���L������~�6�������:�������l��Ͽ#�5k��>�>��Բ������5�?_��9����|�\����,qq/eu���:Ԕ��}O�m��3뎓o���mW��em�*�?{gҤ��m�~ŝ�P�� � � 	�0��D'Z��n��=��)���
��"�A��0P^�W�+�V�/�q�����ݦ���k�ngv����<���`��M�G����޽���V�@��m_��r�#j{MUO��v�1eh.�(��9�W����f��̒���
�UA6���wȱ,�Z�k�;kS�4��eY��!w��X�7)�vh���������^'�QF���Y�L�,R���8���/�����N�E�K���n�jÍ�@���{̸}�b��A�s�/j���^��c���$�T��w���iG�G����P�5A��tZE�?����?�����`��?���a���������/��S�P�F�&]%��}gYMuɄ���%w��O�ϓr��^�C��c����1�Iخ��:v�k��p��tEk�h�#([�����}?���']{ە��z��Hܲ٨�j��/�׳����z�ۻ1W��Ju�㙙W��`>�{�7��<r���*׮�$=��{�$��ɥ������}�Ft���R����G���=9��_#����9���������O���?	�?M����'���	���������?<�������z������Y�W���]�߇�
�?�?n�g��� ��ڢ�Y�J�Hf1%2G�\�R�e1/�C�qGl"���1�s,�����9��O��M������A��	���M����ڿL-���������u�d���Goж���_O�N�[mGJ�%�A�U�6���^����6��J�*e᠑��������x��Ӽ{�y���R�	�;�Z�n� ��N��"cT�׳B���yw.�1ju�M������E�~�[F��b^�?��&���C0<fڰ����G+����?p���`x4��?��ΰ��� ��!���!�����P�A0<f�������l������� ��w���}�����������g��p����|)�m�.�J�05_����/���-���E�:([���">��yU�(��7�|�H�Gu�V�C��ȅ<�$��;��4W%}�r���x.
٭{(��:��ً�ܟ�q�ڗa)_#>�o2>z;M�f|��}�o�=�o�=P���u�˙ו��h`N��w0��`u��,%m��p���޼���E���V��ߟ���~Λgsd�!�i�����8�^&e�zp}I_��m���{�V�N���EG4�g='����S�׻g0]Ŋ���:ۊ��߰����`x̀����_+������h�����D����O��?!��?!�k�˿����7����I4�����'��M����?>�����(g8>��(���"��.��<I��J���":f^~It�q.�ˊYD��~7ڠ���S0�������@1Î��*Ѥ�!�
�q�K�J4�7�;����og����.{N;��۳��SW�ٍ	��޾�Bk`򰤏�P.%kazlʺ�u:���N̅���:��'j�B�Vj�r�"8��Vڰ�S����)��o�F���o-M��?��OѰ�7����?����?�� ������#���^���f��c`��	ڠ�p�>������ԫtXp���]���l`���3��������G[�?c�\�%2�D)f2�!iĥ� ���1Ee$+2�@�Ȳi,J4�r�$Q��P0"�s�A��������r�g�ƦW.�%gn�	$�7k�.���N�[�'cs�e���CiW᱗;��|����T���Wc-����,��J+�M/�fw�H�H��[��S�x�\7]XA��nc�oS��J�������3mX������>���i���?��)����O���0�	�0�	�p���?��3��?v��
���l�F��? � �L����x�l�������2�h�:��"S����?Ե��uR�����Л�瑲^֞�����~ʜ.]v��+V�ː�̑Q��z�zjikzt8�~2��/�ؑ����Ѿ��r.o�I���Tfq컔�J�pڳ|%\I۟H��ӱ� 	'�Bt�?��a:��⊂��NJw�Ӷ>A씳��9�'�(B��І�~5�����\`����̀����_+���FK�|?&��������C���������޳�C�AO��h��?v��
���l`�����?�?n���|�E�%��S^��,K�f���"^��H�>Ix�&�4�cI�Ɍ�sV�h&O�$�R:� ���h��C�>~e��K;~6�#���|�$�bx���-ӈDO�q9��%����q�m��N�l�U�t�TQw�U����	�%�4(�QۧN��{'�\�t��Qv9�6]qCk`t�UM��[A��[i�������C�fڰ����G+��?���� �����������������C�������V�?�`�5����xg���Y�~����&�'�o����������/�֘P�9���#��8�������b����_�����C(���utG�U�V�n��<z������_�z�+�ܑ�yG!���7���>���VWj�_��F�ś��rº�>}����4�قp��"ތ��],G�������sy�SU��_ރ�:�xl�Su���!-��ު��O|�UQ���ˋaNT�@�z�qo%��q���ܾ�_ت���8S;^�}�U��lng�����v(���l�����*f>vs|2Z7>--�j��/u�	��2z8k�x�:<l�a���x����Y���-T���yO@���:T�������P�[җ�����ד2�c�~�b�;��g��^�h�w���Jė]%թQ��Ak{sgz����m��t*覾�Q���E5\��dW$�TnJ�{R�݋��֩Iޥkٻ�,)�h�U/�~'���w��o���`s�������V�?�`�%��m��������������������?C�P�7A��^��p�������X��Nki�������Z�����?��A�����c~m��������/��n�����F ��-�)����?�i���Ceѿn6N6�fH�E�`���e�o����W�t���S���=��Xx��C-ȵ�ϯg���9{���>�U[�#�B�j�Ug�������u՛��LR�E�~;^��{��9+�S;��vK鑡�N�:7?�fu�T=�
�I ��3}�����:���D���� �7�Tew��TULO�Q���wJ(M�o��h}uv�t�s���w�Լ���v,c�p��ﲭ�f�P�Q<���E3��k+��?v�������hZ�����6��g�,��k�����/�c���E6�/r�v2o�,���o��{�P����a�x�����]8d��J��,��͢�B<�{����iV�{T��)L��=���=/k�p���Y7ؙ=	�3!m��9�o���t�61�'�So6��N��k���~����1/�)�_������q�H����>Re-e:��w#ש����b����2��zh���0]���q;>�"+Q�*���\4�*M=:�l�[�6��\��t�K��P��T{��?���L����
���]��A���7>��p�m���������������!���?��V�����3��&h�������4BS������'�  V@�A���?����?4f����o���G����3ԓ�?��G#�E�E*�<e$��XN�1D)gH:�HF"32�,&)~��GOg��$������^?��7m���^�?�6�7���3��T����_�z���N���u���vQ�W�{&���$+eA��6;��q%E�9�nlMzJ� o���p�`��\f���1̽�W;��^�-7b��On�]*��kg���w�RV�z���viib8���Sͪ�?�3�^�7�e�a��)��`�o��?Ca��?�?|�B�9���E{���pД��h�Á�k���'���'����C��P�����V������6Bk���`�ߙv����O
����>�L�o�^Na��L�m#VR��j����?�_~�3�d������:)��{G<����|?EҪ�3�>��W�d�R�]���!�n��A������p)�6%��r�WO{_������u�Zr5��ʲo[�K��zē��go����3���}�o�vZ��D%B�rԉ��2�핥����yv��p���4'�`��7ϒÚrʞ�:5�S��{�x���TAd�,m�l��M$��.��6�e���7�0ҋn57�����#�i=(�8�X�"Ddg�7W�K|~ȭ;��KN�R+�(ΐ{>�6G;�D+�?�������0��c������%��m�����@��?A��?a�b�����Fx��?��ݷ�&>����	��	ڠ����G#���l�qd�Iq.eB*J��9'�Tĥ�@s��sl���]Iw�Z���~E�Y�C}3��:D#	$����R��~}A�$�J�X�+>{��Ċc{߽�9w��#��Y��"&b���4f���a@����&`��������i�;'v_�Y^��ԽБG�mᒭ.���P�f�)y��m��JT��k��M�4r3���z��8lBm��2&�x�CU9l&�ߔ�g���/����=�iV���(��0w���V�p������������Ȣ��������@���P���?� ��1�����袎��w����(�?�hu���t8��?����C����?�����*��O�q&i�
!�$L�3#��PMEt�q���I��t¥��|#B��������O����.�p��W�#��bݓ�N����&=_!L�X,��z����Ϙ2O��?KK���c��I�+�˵�%���Ck���l�c{�o��@0B��wC�p�mJ�Dײ��p����
����>�a�C�@�����������O-@��aH�	�����d8�u �?a��?a��?��k@�������s�?$��2��
����G�_`�#�������?��k@�������s�?$��?4D�|C@��C��9@�������?����H�7��J@�r ��������a��������4�C�Gs@���D`C�	�( (6%�4ey2���R&�I!�<�8�	!p: �0ao[�*% �����C�Gs����x#�3a%���l+bmƘ�Nyz�I�Yw�C>j{e�����<��;�DF�B�$��sP}߉�T��Xs2�&<%n�ɒ�{��%�/:{{����谊�Z���Q:<	s��x+P8�!��94|�C�G�@��������h��?� 5������?0��?0��������0��n���C�Gc@��? E�
��f���/���2���c��>����ΐ�Kt��akc����[�nD�gc�/�?��[�q4}3OC�zji���4uuۓ�]l4�	nF^vV���I0$��<�<X{����cn������� ���\ߣm��ɞ7O�z�.GSϸ��s�����jd��K9��:��dK\�&6��_y���Mr>�3Z���87s�4*���a��篱�o��?C���?��ϭ�����h��?��������s��?�����y�����7�8ٿ>^����8GQ����G���>~��4����_�U�m�����$��u �u���B?�p�] ��7��0��j���h(�"������_���'����Z��oW�e1~W�u���8+��e<�����뿳�O�;��|����a)۪��y�J���J���|���G��ߙ��~�3�M��_g�:_w>�����S��̮\H����Lڜ��J}%qG2�a����aS��4se��/[X<�/���]�U�����w�wv8��ϥ�A9��Q����������e\��2����q����^e�<{�݁��]�tX�/��p92Y2յbX�~o���e2�>Y��ɞ?g���D<Ւ{j�c�&������+�j�u�l>��J�ݛ�]�~y��ŅȎ�6��ۭ�E����.�cnj鞦�j﬷�ޒ7�g��z��U��������.y����[����$� ������`�Q�������������ǻo��';�i����Qw��s����ڟ���|h��?��Y��!���z�'ռ�8Ƥ,z�m�I��I���*��);�����o�<Y����&��ɓ������1ܧv<�zm;+��1��	���0w��&^1�j�����;�ڐE5���g�o�ϣZ7[��f}����^���z��(^_�ʗ$k�+�R�/όo�]�$N*�VY���/E�V{���;jY�R���G��Nxj?���9��)�;�/Ej-06�_�}��3zv���q��.p�����?v��8�MC�6��R�mnCa�RZ����L���;������[��>`6;򒶲�g�����go����_����.y����[������ou���%�ò�2@�@���̃�?	�����K���ۃg�_]���zQmC�mlU�"�]Fŗ�W�?���λ2�Ee�j���8���r�j�_��W.�+l������[�;�I�5y:w�����]�l�˙#�"jۖ{�7�dj�YѺ���Q���>Ŋ����z�H�>��A�f��d�=��*�n.}��_�Mz���<�,Z�s���%�W;��4�r�h��Rl`k���^���� �)_?�ó/�p�[C<u"��{ZT�鉲�KG.�������0)y����fL��ʘ���PE�|I�f��R'�OH��P[p�de���K�$�3�(��b���]��@B������u�?������������4�����g-hJ�A����p�A���W~U���[�o���_'�N�T�~�t�l�_b�"�UE���}/�0E<<E+{�^����y�~`�g�t%y�R�a��3r~<��vW>9��8O��C�bE��Zy�`7�T��g��䦝���Fǝ^\�w�W�ݠ8>�����o��n����d�:��Ï���/Ƽ�-y5���O[�h���1���^�c�dz��M�]f�t���!}ƷT�lgf����� \%f�m�C��}e *�����3��,��h5�	�D(���̀�����9ʫ���z�uh�Zf�n�+v�*����O�-��w����%���7�`}�P4��V�����+w���H�*;��U�9���(�~VW�tN�♤Sb����Y�q��rT�Ñ���Ց�)/�'��n�2����t�t�qz�-Jv��a����=v���DE��z�{^�e��S����u+) �E�җlA�z��V���W垜���]M�`/s|('aY�U�PX��h8ݕ6;I�x�o�H�?��k��?(6���5���{W��'�o���S%j�Q��ڋ�X#E	0���C�.Ã,��(�7�S�_O�m��$j�v�����*3��qIu�����FX���~�r�l��ֺ-a�rМ�_Ӊپ���z��g���?�ڝ3u�SQ!��Ny�f[yNә�u���~Q2_��������X�����ʔr#4uO�xˮc�d���P��l@B�A��14z��_�@A�A��9���������4���  ��>��y �E����}��� �� ������ׁ����7?��m�� ��7��$� ����������f��A������������Z��'|@�qD)��D,�˳)!���Çl��M�<#,)iDP,'d�����������X��I������Fv���T�k�O늙*���$ix�z�����ޝ��U}J1�?k��G��-�ur(ҮVr���x��G簛.���5���&�)<K73i�#,��Z�N��w�^�3ӣy�E�~�ՏB�]+3yN�}{�-fv���0��ug�>�������$�1p�ׁF�X�8P8���5$���������
��b�fP��o����9�u�W������H�?�����]���q�����	����o���������B�������/��ւ_����������KFi���Y��KעI+����q�_U���d�g��^}
��R+���E�E���]���W�me�J��8����t����벚5f=:��D���R"�>�[����v���b���mEZ�x.O|�R�^�xI�.;sahb�d_bLF�ۘ�x�H�e��v��}�2�-���[��T]�$V�g�Ȇ(V���$[Uo#~Y�e���V<`�(e����v+傛����eZ��;��mf�˻[�P>�Qϝ�P�[%�G̾������+�KO��4�5�����n�f���������Ш���������H�?���?���H�?��ƀ�������.��G���?��Ǐ��(h����?Ő,��:���'�����Ԅ~�A�#�:^����������x��������I?���O����?�p���X��(�<��XHɈ�0dٔ�I�棄����;!J ��Q��{_��U��������0��I�Vχ�q�����aW
��O_6q���^m�Lgy|����|�n��w���(��ģ��?j�G�����w�Q�����?���?B����sw�O��Q����t8�?���O��A�ׂ����� �?���O���4���?I���c�x6%)�e�����wE��A&q�qi"�QD2Wj�����*��п
��(�����Z�'�?�E�s�	~�$��D��l��o!:��ro�u�q�Bq�N���"	���+�2֍���:��,j9��kL&)vѣ�@���e�W,1Iݶ>Z���rE(�`1[nO�LK�q�,��Ι	��������`�KMh����w4�����9 ��ԃ�O����?�iu��{�30�W������p��Y����_MhJ�A�; �����O=��B�{-h��a�[�@��?��v}���o��������W@B�������ZД���w4 ��s�?$��|����g-h����7$�?�����������7���f���ɒuR.����M���s�'�x��I� ���k�q$;���f����f(��4"T��̲=ݶ��&�r���KU����u�ˮ����Ѡ}�/� R���$ ���-�DHB��w�x@�S8�[��=��陞Q�g4m���T�����?�_����F�졯~�޿|�o�������k�?������}�����۝߭�ߊ#�V?.���|��­�^��Ǐ������H�#�yEW���� 	!Ah�P,�2�� /E���7��G�P ����P$�����&���Sf����������|���_������_=�������C��C~�x-��r��f#?����mp���'ȿ�F��6x�&~�-"����^t���[�O�D��͓��|�.J�,�Y�bC��lQ�½�n]8����q0��R�ظ1��k��BCOi�9D�T[�Ӝ0̓�1ͥ�t��Uݼ�4o���C@� ��00I3���h8^n���-a	��6�2�U��Ҭ�#:_�}���z5��k�NsB5hB�Un�%�w�fC�ظ���X�=�p����P 跀f)�D*�U���*&M2���--��s����Eߘ��Z;���c,(�����D�\,�ٸ8��]��,�Ƴ&��:<G���	��7�0ǖ)�����~�����j@'8�t���wgl�"Wr|�Ϗ{V%���~^n&��(�z�Άr�}��c�a��L-�s��=�5��I"�+nEs�xk�^���ʣVjH�X�S����r���1d'cD�x:.�G
���Y�۾B\j���P�hI_0E="7 �� ��K��h�R�dgR5����3DM(�ƣ3F�B��
�)O�K�z���0ߡ�S�Z��:8T��j����CШVƜ�U�\��Ȥ����b�Kb8�!��
1��6�x��:9�;�s�P����@�������h��W�6K%�.FU�j�K�N�C,���I�i��L�K��3m�@u*�(M�%��4�ޒ�%@�t�,ՃR�Kх��N<�N|�v�m'�NS�x�'���q`��p��v?�0��fM�5r�D�Nj|T�C.g�-�� ��#)82�����q�����u�p$
�������,�b�M�����D+Ѩ��=��`2�`���eJ�I�_���@-R�U!��I���#��P�ZQokY��˶}�����r��@kf��,xI�+vM�&i�Z�A���p����Z<�,kħh�,)+����(��'��=�Ҵ^�XَF��~2epA*��m�?e��D��C��?aeI%�/k�FeX�X8�o�ٌ㭋���ɥx�������K�J)�T�L��k��Y��'k+&:��u���9p�si�Y�����X��>��nbi&:㬩���a�1F�:��d�z�9�ϳ�D�����������VAs�I��D�Wjq���Ed�r�P��W�E���Wu�S.��F����r(,�9m�O�c�2��9�`� sC������%6�;5��R�(oX��b�A��C3��X�U��e�t�I��Fւ�\)��E��H2�T�ە�d]QcB�i�|�4�@�)M�w�	8���Mb�Nb`��Љ�=�4ɉ/�\ ,��%6�c����Px��5����+UKq���e�v^@�Fv����gw>����R=^����7���+v�ז���M�7���[���2�����޷wg��'��7w�?�=)�\yg&k�{!He���D�jD8��}��&���&����MyW6Q��m���Q�j�НXg_a�c�oG��F�Ijň�I_��7Y6Rd�Rks2�W�%kb�\?�	�K�z�b��r�1U��0��	�Hr�r1�ܗ亊��\��?�it�^�C[ɉ�l���Y�=�wʵWՌ��g�!�O�a�eh����Z$5Tj���Z\���m��o�[Rou[��"����`�rŤH�Q�n�4�M�k���Լ�'�x��i#�2�Fc���!�	�^3�=C��B��� ֛��mU�l娚L��K�ʍ�0Я�t�=I&KT��)z�2[p�I!�`C3Q��bEd|T�����>M�e��
��yuˈv��3�Ȍ��Xy�萕$]	�lf5�h�%�R%��f]v���Z�#�F��f �[�Pi�'��4�@%/դ�:b���,] Rl��Q�^6H����$2l+�� �*�b���9��o�ۼ�Kjܒ�λ��*�yy}�Edgі��K���}��S �g��O�`����y�wf���;�_�A�u�T�w.]b�ާ��i�}:�^��K�%��όr��$�Y��0�ۨeT�M�h`��� q��
�U�lQv k��@ֈn9^�'�M/��7�v�_���#6�aB��42MfR�NI�����1,w�aFU�Do :���&�@����$^��A�(!q����a�mK#����M���т��4��&��Vk�,ÍG&��/�Z�D^�7�J����\�^i"�4����Bp��e{[y;S�,#��R��BY�hz�P�Nfq�k�/d�����o��~���c�����9�֪g�o�U?c֪��p�=��{��K��m��6�����HSf����>�ŝ��+��뫖��J��数�	t�:K��/���[4�v,E�F$ ;½/�]�AI��676%��2x�6TcI���#�Ye"!o"��[}�}�;}��\��)�h��w��C^��B>mi+�xN�mdw�E�;�X�Y�ϒf��B��w�7 	X����%����n�Wqj�}���Cu܂8�V���H��ĵ��������I���X��Nߚ���Oa���<
n��EK�m�F�C��;�P�Õ萣�/�{⃱��/a|f��Ӛ#�G��{��O,�����H�C��?r�����o(=���|&�#~A��f�r@�ñf���aA1_@���X�IXXF�X@d��1)v`��Ϻ�������K�?}X8�������m���O+;�b�ȥ�˓rv��9��}�s,��򣜥{�vW�Yoٳ����|��9�ؾ��F�3�K<�o������?����H���vT��� @|� Y_n�*q��j��,���G3Z�툼�.�W-�<��O ,���]-Q��`冗$Ĵ`�^E'��.����k�4kS=��9b�/���%���y���n(G�3^*�>�5w}�V8I�)�Eɵ�i���=.��}��i�O0�m��I<:�I�#�rF=w=�m*"̛����P%�s��U����eEU�ffHK%����;���Y��=�/|V�VZ��gI��C�[(˫=�L[쾏`y����R����v��߱~ݠ�c��!��u��ϡ�ZP��5����F��<֯;x�_7��X�n��~���c}���c��.�c�����g�Nm��I� "��Z@�2 H�v{�{\���G"K�?q��X0�����w��m*����m �E��⠆�ʊe;�dY�u�{u�AyUE���h[r�i �$-��:m	���K�2����>*���\e~@�l�>[(3q�C�Wz�_�o��P�� �4������.�N����4u��3�[��+�mY8�J��_�%�}�a�Qj7���I�U`]�Wm�˘�֩�*��Z6=0�\��vث��u�����R���=�:�Ʃ�]�] ���_F�B��G��c:x P�<�؄j�y��2�nz��Ns`z�z���A!m�2�#�W5^m�3u�{ЇSүί!����{}�1��=wѹ��ү>�y8��;i�ځ>X~�XR��2��<�i�n-�H8�Tx������!n���
4�pm��(̞Aq	���Ǽ*�i�-Yj��٘=J�|>x�Ih�'g�R%�9h�/�m�6ڔ$}�m"*֔�Wk%��::�� ��5O$�t������M���������7��l��O?m>����m��t������c����7����* �/���
��Н��t�C��A��t��XSQ�G�ƽ����_4��j���׀��?⋬� �m��F�S��''�J}W�M�u�R��f඾؇�a�P�oM{���<�	��*ߒ��CM�v��t!<.��h�|�P�Z�ro�q��)g�}�5os�w$�rG�)���C[��������(��;S1�^��I��:��C6]�r��Hꊁ}xC�ƻh��[�[+6�CTP%^�E��E��&�H���b��h�r?���j���Q����̫�2���;1w@�3��_�My���?���}�g+�O?i�ք�n�#�����<�9��d�a9���lq��q�9S���3_!��S$}�X���������h�bX������?�ǉE�s�>�����]�,�Dt^�|S�ԝ�������9�jN`j�s^��x���)����$C�,^�
$�Qqn��U�
{B�<w��+�#��;�-����rthÏ�*�B2��'��
��GRD9y��i��3��l�>��6��ʌ��r.5w5��	=K��L�����G0�\��]��ui�
�d(�=���t�f��Ԫ�w�~�Ֆh���c��d��_���uC��%�qgy`�}MZ^�)::/�Y�LW���Q{,Х�_0����B[��F�so���g��T+t�훏0p_I��W9у�f��ۻ~ߦ�(ܦ��� �2�@��v'��@�V�R!Q�N ���Xuc+M�R	�1�ԁ����u�����T$�;;���I����-�|��?�=����}�c�|4�h��w�?�����������L"~bĻ�/[�D��4tE����jz���a��ί������`nfv~N^1���z�?�+�f�������[`R�E�m��&:4{x�4�z.qt��ҋ����Օ<��@|����Y��8q6E�%�V�v���a���Tlo��f�j.BV�!�@r���F�+������ocZ��>�>�h2�B���.[�Bi��ĉ��Z������{[�6����������@_PQaoZ�3��
yX7n	�q��()�"�>���EJ��V�&WÑҡƋ17NGB+�*-��p�m��߼F�Cp�Z�s�E�S⛌F���x�Q�����*��h�+���筻53�I<�0l���i�AH{ܨgU�2�@$���bF�96_� ���6�bȡWn��}���b�������3ᤠ'U��i��*��$i���`6�?ܕ�~s��`�ѹ�A�v�ܓW��S�U���Ҧ��rVVZ��%Sm%�c�x��~��vk'�#�'����U������y�����=�M!��� �3����D�����t���=�`1�,��ά�¦�|F3��i꙼��X&���jV�X�`%�̔RNaKc9��+1y�`	7���>y�7?]�����V����~��L�I$_%�Q��}�N�Ҍ�9�l3��b��PLfJJA�2&�zM
���/�[O�1:�r���T�d�J{�1(����%)òf���cQr��,���c[������w�/��Kl�����+=����A��t�������!�|lt��P�9f�ٜF�?��3�?���ܤ�@������"Pw��N�Ϥ�L�Ϥ�L�Ϥ�C�:��L�Ϥ�L�Ϥ�L�Ϥ�L�Ϥ�L�Ϥ�Lq�sP����j��f�N��l�9����!EI����I����I����I��@ �@ �8� N$V^ � 