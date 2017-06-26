ME=`basename "$0"`
if [ "${ME}" = "install-hlfv1-unstable.sh" ]; then
  echo "Please re-run as >   cat install-hlfv1-unstable.sh | bash"
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
WORKDIR="$(pwd)/composer-data-unstable"
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
docker pull hyperledger/composer-playground:unstable
docker tag hyperledger/composer-playground:unstable hyperledger/composer-playground:latest


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
� QY �=Mo�Hv==��7�� 	�T�n���[I�����hYm�[��n�z(�$ѦH��$�/rrH�=$���\����X�c.�a��S��`��H�ԇ-���i=��Tի�W�իW��C>�VH6Z�aÐ�I��e�u%�ki��x��&8&���l��bñQ��ƹ� 0wT��ж���cIվoR��)t�e�����e����Qeh�Q ޘ���7��;��C�H�Zp͏%�jKj��fτ���"����"��a9��% !��¬0k��e��jz�N)U��|�*�7��5��;� Z�u��9)Cס�J-��j�^tS�K5K����0��p�y�@���[���=�l�RM\Fܼl �A��fF�9�˹ÎF��ޮ�U�"X��т~�G�ͺB(!� �f����vP�(Ì��-4*P���80�$E��0˔�"/}�I-S�aD�Z��z$��P��Z䦄z������`�l3��8���*�QY�}��7�D���0ѱ���>�>\��"L8S�Z�mg��h\�6P=�I%$�A�4m�)���*�b��,���UI�����:Ai��_��NEL�v��� f���,��K�NװN���+d��-]��"gP�y����� nG��	a�Fh�����|M�W����?Hq4���� �wN�����1��@�R���NPa�y�2H��W�?�q���(Ϣ!��?��o���HM�#5�nR�Ѷd�'O���?�jaQ���%���Q��SN�o��4xF���fWA_�#͐д��QH��a�c����^���.�������)�'h9>��N� ��ؕ������<��x�b1v��� ���W������h�H�Q�0���ö���f� �e0�����@�b� u�B����}��i;�l[x��`ZjGr0��Ն$Hj;M�2��ؚ*C�&5�`n��F��Z�)��p:��ܔ�b�]c�Ck�*�xI�֫�	u���Հ���X��5э�C�	3!I3�R�� ����&$nq��P󄉽���i��E�ڪ��$Kn�B�hk&��l�aw�Fp b�˼PC��Vc�£��K�ph�q��Ql8���(��^��PL?MW��O],��Y�	��&��U'������B���o.���� ky��։Q8M�'��am��с(���޸��)?����g�;�*��O�*d���g�Zo�6Yd���:�i��%�RG�M�[�<����-��k�;A6��5[���$g���¹�¥`�ܕ��q%��OS��$C��r/p+n�h[���@�A�,�sQH�/���1g~3�v��w�^G����f���b\q����O�S�p�1b�q3;')�l���reAl�"C�z�Qm�sc�1�1�\�_�B�_{/�(ʮ�V�Ӯ��4QC�8T�]���ll�A�ݦ*7�A���)��^J(��Ɔ���d�6�qa�3�˨�U���e��h�����"��N=\�3�R/�YP:y��q�d�m���	i���mI�C����c�1�?Dwf��0��'�'뿹����q�����;*c��x�g��م�w>��H�K󋫙�&b�AZ�6��aU�24���nƒj��ֶ,��H�1��Ζ�o N��f�rTI������H6A/C�iueoe���] �b�D��9�p7�d9�:�˕l!����Re���ڠ���y��t����8�{.��랃5^�'�/��F!b�Je��JU(W��ٜXة^M� �8�Y<�!�,�~6R����,���\_��&����╅�
�y��-x�����۷�_���JR�@���ۭ�h����K����m2���:��5+dh�]�O�yV�=<,
=8��g#�e�jp`�y��f6�Y���B��,���Ʈ�$˹��$���̰����_���{���T�{��-��C4�B������(c�@of_H�[��җn_�����y��9���x�Ä�����A����������o�<���������g.0��+�U���5�e; Z�a� ��ꎷ!�jI�b�)��������@(�J��]=���$�M��g;����K8�Bu�*��|���1FeΒ���G�H�h����%E����:x���a��h����\�W�Sh��!�~	���.Ϫ����w.�K�fl�˃8a�������O�f��9n�������ǈ�b��4p$�c5�8 �qn��h׹�/g��S��z̃Q�C�g+�x,Ą�0�O���:���.�7_�L��7�����C������+�߃ ����]�f����,
�n)3�1���a�a�?˳����{��a:ms�̇��V?H���o�-8��#:���������7������rE�#H���2�>�T�� d�H%K��[ 6�w���B�Qޑ��%.��1-�]�jV��v���YҚ��o!7�\���!�}l�k��F��CW�<y�Yȉ㛿�F��f��$թ�(��Q��q��,���
�i��<8���?���j�^G+�����+�e��k�5�b�V��-c��������'����	$�#�o���卆K<j��Xƒ���e��0�B\	��ꅓ��\R,Wʻ���p$�b^Hn��u|� �c2ד�%�8�r��r �%�2��.%ry�!�*�ţ�(���t�,V*�N���b�J����PM��B6_]o����dE����Q�F�I��L6�9�w������Ɍ�M��	.ne�D�xEL�z�Gq��ŮΆ�]��"�v����@'^�P.lo��`���P����ϲX]�u��V�|�6kU�������C��v�d�lk��	�P��@�\2�厡�[��g\��|�L{�0���nA������'�����������Z�Ȯ �S�m^�δo�r	) "������ujg�V�0�mb��+���W��b����K|�����:�2Y�f�b�'��5��t����hZ�r�;w����y����K�&��ϡ����B��>��ߛ���<�P����Ia�]�k�@�Ӊ\Ƴ���S��o��y��^���@��:p= B����<V��\�{�i��m.����F�|q��\�Õ��㘃� }���t�I�d�id�wfO�]�~���Tjc^�����m.������_�Gb`��s�~�?Y$�T��F�5��׿<jj�p�c�0���os(x��/�����
�b	~���ܖ�����i�ܡt�������[ ��P�B{`7|��` ?J6�	���f��=���L�
�N�O�����;��p�OC{�lx�xϭ?�2��p�K*���S���D�X�?ɘ�P��#��t��ĸ�v�{���j���
�o��&�Cy�mbj���7�1���D4����f�W��T���e�?�a���4MS��� C��s�o.�Λ��n��S���0��-�<���_�R�;��^�N�X��x;�T �p(�����^�e�����*Z�+�+C��j\L�G�_���
��r�����U��\�[a�h]��5V��**B�s{G����/�-C�Q�LC�b&�)�\�ndSBU$��z.�Mm�R��i�lRhdK��R|����*����V��3�sa+�h�6O��R)-'����=�S���n����vw��j%�;b*��*q��wБ[��_�r��K���;�F;+���=�Xz�?������n�J��+=W�5��p�̙���wj�K���9�%��.s�?��q�,w,���	���0��m�g��«d#������[͕s]ѭYV����3�ګ��f����Hܦ�e��{�ơ^�_5k��)s�N����tS��Ƀ�A�5k'I���vk7���vk���>���6N�bw�P�2���LJ(�g��P�ӥ� ���Jm�$�?�)Z�����ln�ubf���~��:u�o��R����w^'ծѷ����k}O��wv��A�r�J����?�nu�R^�e�n��h-3�C](mF����^#���vV^�J��`dR);#�v6P�'sB�ĉ]1�R9A�nu�Ӈ:��8�*u���0T��߳OOYX�k���\m弳�zE2��ڮp�/�T
F��n�uTo��t�+t�B�QO��-k��_�0���N(�Df+�m���I}%��j��i�d�T6�W��r�h2�Ϋ��)[�����F�F\z�"����A's�$"�C����O�a����}˩��#��O������������7��aݻa|]�A�  �����a8��M��=�����C�E��]�̧�'��L4���]P�����X��Il��$���f6��(`�'�;�Tr�U��?�wW�Lf�����R�Qa����jR�u�����#�2��W��ʱ"1���U�
u��|��,�� �
1���W9��v"餒�M)�����#���]9��nd+�x����v�����Xf5	��劮��۹쫈���R[���(_����n�>��?6:�������v�}W}>���7�/�s������Φ�ӿg���9��7��l�)��'�a��w��p`f���3��ٔeL��������O��W�R悔�~���~�w��H���7?eW��+u��ec�U���)
�%�xT���z���Q�.�5�.3�8#����W�++K��l�_��������7���O����_l��/���̋�_=���!uY�Ra���45l�W}�˥�P?.X.W).=�~��Ǘ4E��6,Gm���li���B	.C���O����,�>�d ���/���{鋥?���%�����(��{�� >Y���G(�s? Ǖ!��:�|��0�K!�o�����?������������'���~v��K����i[0�y�����op�����a�o>���e>�=����e���KI���A�������zH�g`F����OФ�#�E�����7(�$���]�����b�Z�� '��{
\����ez�W�PH3#�H)�ª����DK���"l��	�͖���m�d��'I5>��A���(_���묒����բ��*����j\��V��ť#��j����삐��~0p�U��=�1��cO,$%]='��_D�"k���kσ���ٻ���ޥ�2�ݳ]���A�e�=�F��Ŏ���[��q_����(����q���<��"x��TH},�ĥ��T�o�H�!$�xG��>;��d&�ۙs&�=�F�3'�|�������}�����[�"��T�M1<��+���,�e�*1�K�VX�,'��LK�8�e����x��>=���;�W.���̣Ez���by�Z��x
�#?���C�X�~��V}'�'�,�J��<�.G(�ϕ�I�����!x<ʋD����Ǧ;����A���0��;}!G��u�2'�v��s+����6�^�����F���Up|˳a}�r'�-������"Qr��p����_�鍑�n�\��H���?��5����e~A�υk���-Iz�\6��\��^�s�A��8] ���\���m�,݅Y��)���V�E�F*��k6yvp˩+�`Β\��~5�I�Om��󣤃\h���5\�e]����#�'{�:�,�O���'���:;aZ��W�`��OL����,t��H�O�ܘj�J���+Tee94�+�ҨJ����������۹9d.>WVH�]�fH��H�}D'�Xu	?]���:����V��*��rD��y6�u�I^�����[��#��x��V`��gz�ɲi�EP{�h>:��vx���$��p���֯~�~1��50�Ǳ�}2�ی�E?��$l������/��2ǉĝ���d��u���;Y��I������}�n��o5(/����?�e����8��wB���������~%�w���+���_}�?�������~O3�I�������̀�<x��_:�ǯ&��W�|ۅ�p�/��n�����X.�������L��fP��q�@(�g�!�;�je�M\O�ޮK�������������������_��7R?T�VR���~�!��i�,L������%���量��i��/�:��7��'�֛�����7N��Kr��$5Xfh���Uj�D��P� Q�B���A��'ɛǩ����e@ ��lߎ@��0e礴̱u�[��\����I��N�Y_3F�����DCzs!��B6���r�Yk�NZ�NGoRaK�<��x���)*t���Q�)��	^i$�y�Ϣ��<*���$8I��m��LT��*�T���<�#��辪�M�����DN� O��r5h���f�����pߋ�g���8$$��V�Zh�L�öxm�df���,��9���JF� �Y�#Eʑ��I�r��yJ4C��`���	�RH&�9����R4��ܞ#+@=]�[G�*a���q+�i�HE�m{�ӝJ�d�<��(k���@�u+A�>u
�Fx��%Jʕ�b�H�W�	�.�6<u�Z��:P�����Evl晾�A��T��"��M��e����+V�'�J◫*������YI �� DQ��Ԟ�]�4y"Â��k7�xl��a�9��G*��FLt��Nv"��PgJ"U�5��/ٌ�F�-H�P��x�&�r5'W{����-�+��4,�Xv�FE
��y�g��Bp�C���+]�U+�< ���zT]���I�E����I�\��KP��46��Q��V T�1'��Aƪ��$���@����gxY�$�1F	��R`�t��pi0?C��R�d`p�'hkH�z�m��\>[ù~�pC,�,`(�C�0'ݩ���ԯP��W��o�
�H"�g�6�TXا$,ׁ�"��G���oie<0F��gY��5@IT����6��1(�*5��zLMFe�fm���T��w��9�9���l���7R�	j����6j6����*)z�a9�|��Ba)�2$�7�����txd�A����!A�Є+�J�-��	/�e6��u,(�)U��_��,\�-5j�U/V:S�Ҥs�������6�<�m+y��� ���n[�ܶ��mp��%<�m+x��� ׭߹d�P�/�I��������w�ӭ�_O�����R�����s��$������������/Ō_\;��چz�!��d�'~���v�S������^;�փ��������������wi~�x��h��t,%:���ȧ���vb��c�o0�7�ݽ���tM���Ҥ @�r^ڕ�3�z���L��+���P��lM
�*�Qly�F�h>l+����5͙ ��R�ƌU"2���x�8E��p=m�Z�v��zp���`�l�C�M���+hN�4���Β.�4����Rhs��jc��g��dà;R:�B;T'Nѱ<��:͆k����d]�L(�V7��t����>(>eKzNa��KVM����+e��{�8.U��=U��'R�`ynԝ6ᨓ1�q�l�f��ˋ�V+B'�v$�;�lFd2{#�	2u�q�p�*-!�0_���kJ[o{������R�J]Xe�}p0@Jf��ihJ����Gy�Q9�95���1��U,Yjf\#�����j�؎���d��9�<1��0U��,�j�jZ��T����B�*�%bՀ�P�L���TIv
�L�"7U���Xd��=�7�e����q�A���,�f�ՃϧV�r�������}�ԟ�S?y N�R�����.��w���a�����SI\>38U�E�:���KC�IYv�(g������3��R�4rn=Jb�:˵�F�Tn+�6]G�I`eU��G���W�d����&FC!�X���]�N�\��()ޒdt���~g@t��^��t��Z0 b����4y,IN���N�le
���{*:��>V�\����TD�F�9YM�(��R�&�g[����ۣ���'56��$���4���tXz��$�Pd=Ɔw��p���[tD�^�hsH�UD�N����	�O��,`Z�D����y	c��$��!�Xٙe���fʸQ�FK� Y�)F��I���rq�6wzT�����xP�$��Vt+z��� ��igL>�4^�+�%F��%��xI�[��(*���j�z@4�a���� ���K�����(~�\��Ou�t5̀:�+-�3��`���y1��/��\4c�߀���G�.�K�T����B^m�U��o7��vwr S��c="�`!":�5�e#nr̼�XN6�&"�o:�,)��P�kM�WzZ+�z��N����歚=���jfź+�JX�F#�o�U��a?��*�yÓ�k�
�~�c���~�c�ϱ��xn�9�Ѫ�C�>Z��V�w�����=�ڕ\H�Ũ�A�jtZ�V����L#��	�?�q��ӏ;�G��U8�ڈ
��#�.��)�`̲�!Ub,�F�FY�����p"ؕ�ǌT)�$�4`��VC�װ��oX��KPc�I�c]�y��Q�~�˸C��2|����:��t�Z]���b5c-� L�=p>�W{�
��e�;�	�X����X���5�nz�F�6D��v=��-ԥ�tv�P#�[NĽzKe�¨Җ¶^�5�%� B\y8��1jň����R5S�XP@G�`H�D�7/�+\�DO��茶t�B�p-��Z������I����OBNB��>�$����/G4%+��E��0u�b<��A�#h�I�̆V���K�����OKt_��c�#�s+�F���O>���'���v�W<ʲiw��S?�,�A��X���[突�yV��ֹj�5��p�}�������$Wm�\sY�|��N��=��Xw܁C�?f��S�$�{v�? ���6���O�ǣ���=�G��'1}ᄝ ^?��4GVZa��R���۪��"��>���A8 >��y^�	����M\�7��������]�-��lf�=n<�(� �~���o�M=���(���.�^������о��]г_��Z�]�=m����'����t������e�=����_P����������s���M�����.h����D����{��=������!��d��wA��;r_�7u������K�?Ùx���t���Nh�G�~y��(��>
�^�φ��o��f���]Ў�?��w�wJ{�������g����{��{�Gt�A7�������� v]�������%}#������e��w�c�/yu�>�C���Ϸ�w/�[������{����q�gL����`�������������+������T�����fܐ�P4£Ϩ��?u��(h��7��<rr��\���j���3x��nA���z��)�jx��E�i39�ob~��U��2y�IU�t�( FvC)����tG��G�Iw�L{�8������P���>(d�0���u�G�tc�zA)��u�Hl�����p�e���q��t��&�E�&V�q]o<vĢ4���h#��5�I�V_굠99q��j�t��P�t�xYw�]�֧O����7�?,�������]k����w�wD{��������pf�����[���	��aE1�����-K�s��B�n�팁��v�鸞��t,��f6��᳒��6��Gqx��G���]К�_��j��ó����
��I]��LqP�Nb��Ǎ^m.E~wP�� #�qE�Ѭ���FoV�tD�D&/{�Ak6���և��
�)�Cf3��h ِfc��d9���ΤIq$��w���c6h_s�����1������Z�����T�U�gVu Ui	�|����"�Sn��?,gkon���z�ļ9���?���z�o�i���3px�S,������Fx{�O"0w������Gr��� ��'��`���X�Ŗ���G����������o����o������꿈��(g8>��(���"��.��<I��J���":f�$:��8���e�,����o��U�����F���a!�;�﵊D�b�tH�ۜW�if~ۃ �^[��>��]�����g�.�ޕ����}�V�O,�Ò���RH֢�ٔu���ԕf;1r}�v����E�
�k�͗�`A��{���O�������S�� �-M������p�O#`��<俢����o\��G��4�b��?4B��1�Xє��h�7�A��	 ��!��ў�����_#4S�A�7������O����ߍЬ�?�����?���C�w#|��+�c�����U߿ؚ?�zk7ͱd���އX�Շ�k��i�ۮ�ɪZ�a�z2��k�|7�Z�֟�����Y�_'��~Ǽ���դ�I�e�Y�����r��$w���)�%�`׾T���([��0��3�]�s�j�֌�p5}��5��	��~�x������,y�_��r���wȑ�L5]�o'ۡ�ٸmo�
1T���[6�-�Ç��ZJ$���\���W��h��+s����R�^��Y�1�p��.�yc�ˊ{�@�k�N��V�������������]ז�B��6���}�R���_�@\�A��W���C�� ������?���?����h����������?��������n�;_��>��}r0w��*��U�vl�6����0�`'ۮ�+��-���%U}M����T��� �t��7+�9���������pm��s´,��}�ݮ�O���]��k����=��ʇ��oz�:g=kD;ɫD�M���n�j��������-=n�-��ҧ��92��m�_���{��%�ˎ<���{����!���p��������p�8�M�?� �����?���?���v����?�����S�����'�&�����#��4�b���o���߻�M=�~�c5�������b��_ �o�������G����_�����A4��?�����_#�������������������B�Y��@&����߷������?����A����}�X�����������������Y����[��������7g�E֙���a�B�@��������-�����p���5�O|���yv��ڗ4��q� H����4~�v��rJD�_t�=~�뉥���r�dd���jI�>��Ee��h9S��qVLe���_x|}w7�=��~p�_Z{�Kk/�lu*���y��:��3{���?��c�:���6mK�Pmco�v���,��R+���?g��*���.����"�,_
���5i�,!�������voNx� ����"�!-;��A��Xf'�=阳Y�#y���+���zq�3�_ ��Vٵ:��D�����ϼ�������F��Kd�R�d�C҈KiA9.�c��HVd$��)�e�X�h��XI�D���[����������'����7����������M?��{w���V����Go���kyd�Ų��ӂ3��	%)�/�n]�HA��|�X�G�r��Î,;~�P���sg4��6�z�
q�e8�rDȋeoc,wz�;��>弛�O�H��[�0Ҡ:�ω�.���jz��g�	�{zS�?p������h��/?6�A�v�����,��?��X�!�1�������?������
p����?��?����������A�������?,��?������G�������������P�!�� �1���w����C�2����@�����������&���7�G������=��g�S�75�G.ns`w������c���������"9�k�2�ɤU�.V!_��Yt���5���,�������Q�N�?���>���V��4����t�7��Lk]��VS�i��	g�_ěa��ó�u��?VUe����W��3H.���N���4�����j��v�O]��l��a��D�粦��n����>N�F^ס�5�3[�t��2�������[/T�u����n�6�V���l��:����j�9��pir���?�C���=W䇳揮�æ�m���Q����;�Xr��k�Ǟ@ǒ�ڬ�*q�.�ұ��N���yT�=���z\�t,���P�v������3���n����D|�*�N-׎ܛ���ܙ�4�r�.C!��i�uJpW��N�k)��%Ivz*7!<��d��g���$oҥ�ϕ�%����yv6n��>�.��������d �� �1���w����C�:p�����$��8��(g���b.)�O��I&��X�h2���)�ɓ<����$���9p���@ǯ��p�A+�&JĞS/`ⰛNb3p�4"��LO�Q9-��)���T�
l�.��7k�J�Kʨ�ܪ3�#8v��I/�=�������J��C9fi�]���MW�����ۻ�OQ������-~��E<�D�ǐ4�M�C�G�Z����Fx����%���+M������ ��8�?���)��M��Eq ����C�2�?�!����sO�?�G�����G��X!�a �9�����eX�k�����y���8���d!�>��H���3��t��ן��mn�7�Ĺ:��|���v����f5s�gk@��,Wmm/g�VӶ��yb�F��K�ۇ�m�:��E�~;Z��[��:+�W[��vK�ӊ��N�:�`*y�^��a��$�?f�����Rg>{��4ew�(�E�ƞ��n˒��+59�F)�NO5�fa6\_���Nv�5R�n_#5o�ʘ��X��.���������
���!���������B&��8��W�_��	�������F��O٤>+��S��ɒH�zߓ��tn�_�hc�/���/u7��
IX�T���w��J�g3?V7c�8�
rK�2��S�#z1��Ӳ��2���>�����DH�IߜW�l�t���R��������5M�� 5�T�?+���?��%�/y5d��9��+��&/:��wCש��m�W��Ɵ��F���P����d�u�j;:�{��y,S>�Rݕ=����Yf+��Z�iԭ�ϵ�M�����(�����/d �� �1���w����C�2����@�����������M�-�?x�����|��[�$_��|�J��P����ǿ���B~��Ab�뤐O_���W=�>绩,��93첫}�%c���b��?䓭���s��|yL�T�6��9ū�}`�������e�Zr5)��e_�n1-��g�O|���������ǹ�/������Y�:�A<�K��WVǔ��з���e��^�ތ}K�֔S�b��j&�N��x��{ڑɹli^�gwh},u�ksim�m��]ӘFz�.gf9���{�����͉8�X�,Ddk�7W�K~��[Ur�%�E�%]��잪���X�������!�����p���B.�/R�@�)#1$�r��� J9C�E2����d1)H��%��(��9`$���C��ρ�����b���F���_�zu�e����A�Y���|wTJ�y�9�nd��N�O~��r�wwj�g
#ݜV���]�5���r#� ���:٥�ս��q8
��l'ɗP��B�^�탻]Z�8��N�P��*I���^px�S,������Fx{�O"0w������G���� ��'��`���X�Ŗ���G�)
�_��7���7����oV��<�r�gR�K�����'i�I)q)+М$�����0�3��p	��d��)�As��������S������?�Λ½���$q��F̨� ���x[�|���[d�s�}>��74�N�^{�ޭ�V1�G4�A�-��d���;��k�q�1�aWi��+a��tM�{��luuWT����p�A��{���O�������S�� �-M������p�O#`��<俢����o\��G��4�b��?4B��1�Xє��h�7��6�C�7�C�7��_���k�f�?��������A���t4��`�q��j�����7���7���7����FE3��|�
���]���p�:��� ��������������v��E��?�O�㛢~��k���?��9�����������	����c��X@�?�?r���g�@�� ����`Ā���#����?P�7>�+�(hJ�t�����F��?X���?X���_P�!��`c0b������ga���?�D������?������?�lF���]�a��p�2���G��U�7�ߍ �ߐ��ߐ�����8��l���*�V��!�������A����?��F�E��H�4M�,�8:r)���E.�$2a2&b��M�T A��8K8�̈́\`EVL�[��������g���7����������M?��+�5�k+͊A�ѣ7`�s)�:� 6��F?��c����d��=�"��K�?����`@�f�׷�pR��T%'�W�ȓDR)�\���׆���lá+����PUU���+�X�ʳ�9�'�۟9�½�-���F�br�z+@!i&L]�v$��F.७〉�ݾ�)�x��i�"|:F����§��Ww���~�;�.��A�G{h���������Ρ����C'������������[����������t�����0�������@����@�G� ��s�N�?��h�`�[�����������A��-�?���2��������?ZCg�������� �;��0�������o�?��xUM�B᥋��i/WM���K����ge�o���Ny��jyr}�I'O�$q���R�rI���c�B�{�p��<��EܭE��8��-��3����l�����+��hŪ�9?���ٺT9���2���E����K9+2a�:�cV���G�K��r����IMT=���JM��,�3}bz0�������� ��5���@�G� ��s�.�?��h]�?�S^���Eq*B�(�,��]����^�G<� ��.B�h�T�}�P���k�������;�?�y��NûN~tv,��S����p�Y6�*��V�&�j���c'�RFg�1�_y���h�FPG}H$#��-j	�t�.�h��s�.�q6��E�Ō��j㏥��s�Y4=�W ���7?��>��S������?��Q�����x��������o���]�W�#������0������4��]7�>��>��ȏp	�D��nЏ0��c�G]M���$�'� �����!�vM�����h����N��L'����0��̂
��9u��%�fa[�����k��.`�c|f7�-��,c�%�-b,)�4CT#��@*�&d����ϕ�X���d{����`C����E�
U����������oCh��A;Ww������_���'��6����T���U|��qӪ`�N�#��l$�22��n��I���@`���/��YJ�j1~n���-_�O�|I��m��+=_o[��7������Ҳ�P��k˚����5g��/�u#�k���q��ꦟ�_P9��΅��^h�1ϣZ�³�]K�Scؚ�F������,{}�k����k�~�f~��8vQ�����{���qk1U��lI����`�Ô�q��S�2�^���� �'��	��&�r|�S�hB���p���{=���銱\ˣ�6��5R+�h�%{�v8�X�I{���<!��D����`��7����?�@��_���������������?����������y8�������w�?4���{�?����?}��c�+�����<0X��}����������ľ��^w~8��g��D'�2�\�8!����8�qc!4g<��^T�Ҵ�˃�j*�M��d�����3�o���f<F��|[�ބ�R;��q>�\`���?�B�g<���(oc|ؔe��,����j-S�	;���C�T���e1]�T
�d)�W�-ҩ5�T�އ���0��s~:hB|V5~$f)��!��R��0��`*]8�������'_��9���L�I���j�K���E8��H�#I�|olw�^���3�＇.�?��|��A�o#h��B~���?���������|�߄�T���v�����?�x��s����g�__��w^_����2�mu}�]��Ϟ�w���^�w�̳ZM��)mw�w){5�/�7�̮jȱ�����#| �v2��}7��n.a,MȈE�iߘ����{���9|*��f��5_�<��mV�J	��`e��y����@�Ƨfʽ�i�fی־�^����H�r�-�����`ms�*T��2["Ta�c^��p.����\�⇡��8��?bR��S�d�������L��,�%m\&)I6Yhgh;��)$.G?�7*�*�*[|n����b�@ь&��6tB�!��m	��?��ZG�߃�4���ޫ��w�f��� �zW�26T��l����G�?�]Ե��G�?�]�=,'$N�{h�O���ߘs9�g�N�qo��Av�J)͐��)�+|5a����W�5�KX�54U�YM���\�hb���.���bo�r-zj�/S&�NERRR�z��GT����7�i�=#ۼ�yPAfj1]��a͹�d���1��e|T�u!�ȏ�=%B<)�ɞUVȔ�2��ġ �%�ry��G���.B�?��� ܻc ��?�����������߃�0�������=tA�!ԃ�/
�_x��맷�o���� }3�^��U�d�r��nE���[o[�!����J_����3�����WE.[�Ӟ {06Rlu8�,xȟ����%�cO�h�Ui�N^/2�����#����\^L�1~�̛nv8�I�'��V"xX3�2<�����r�k����:��o��`���igd��2F��v�$���$�3�\�tqf���o������rl����uM!��d?��S�Lma�
pn�m��;��{���7����~�@�߃�'� ��� �?��'���y�:����Gkh��[G���hx�C�M��w�1��8����e������iL�|X��K��Q��KZ�C����s��)L�Yζ�̈́���
q�-%M��Ao�s�~��V�r��H�h�"h�(
����]��������k����pO��<�:u��1)[�����a`� �9!�eŢO��K�\��p���1��'S)���Fs�ڊ�5RW'?��l���; ߢ�����������Lb��Q���ϭ���������P����A��=������������%��k��(o_��g	��������@��o������B0��M���[� ����m�?���4��&����p� �����?~����B�[DS��s��+���_# �?P��?P���@�5���N�n ��ϭ�:��؃�?P�km�?0�����������?��`��&��	���������?��8��&�>��=�D'�?���c��7����������O��rN����#�UX����O�������Zb_2͸�H��˸�s���5�ɢL8W3NHyF'0-v�X�O���4���D��
{S�/��39��Ō,�k+����<��7a��N���:�A.��g�o,DAxڲ�v���v������f��O�Ѵ�H�B�j_.��z�RX$Kپ�0�h�N�����>�N����"j�H�R��C<�]a�-�'�T�pL!�UW/]O��s6a��#�����ȗ4���p��>%F�+������g����y��
�A[�/�e��C`�����[�u���G�����F�:��2L�1.CENP��4s���OR�xa��t���ȫ5$��B���������z��$��M�����#��~�LD���Kë�~���IH���4-�$0mx����G�P����G��S��+s�6)����+�����,t�����2���8�N7����y}�B<�SɈ�]YN���]S�"2ay�����zn�w'Ց�s0(3�ʬs�~�uwO���c���%����7�?��/�2oG����+�Ł�k�������������B�:������}0�	�?��U�!P��?����������+��@�AS�����(��4��	�?A�'��l�����/��5�V��j��n��	��� ���@'�����	�� �	C��o �	�?��'���n�������Z� �u ����_'������BG�����$�	t��_9��v�n��r��[_��z�q)�h%8s�|mj�y���������Zz��N����kc���wOa�]m�=|yyV{~A��V�-fE\ٜp�p�^:��S����!%is�"R�
���F$��1c:SgPeI�c���îƴ<X�[�ĩ���a�K�&���B�d�g7�α���V|�J�n5���)�%�Rb�ŀ����S�_|n���#�<�����j��,>���#������l��Qq)��(+7��c�P�L�ÝZ�G6a�ԸL�W�O�=�l�q�1��b�/}]�Jm7��(��G��Ch���Z� �u ����_�G�����F������#4�Р��CEh?"��#Iƣ|�n� `�>Ja�~�8�!��B�~]��G�Oׇ��o �3�	�pq6����%q�,��mm��;�4�a�EC��-���?���7���"��x��9��Q�p���̠tGH�h�z��0��grD0H��^o�{�~��c}5`5ҩƎ�y�)��(>���}J���#����?����4����������`/�[� �_�SR}ɷ_�d_V_��>�����>�V_���˕�7�6(��ʰ��?���o���}�V��޳�:���3���sfgwpٝ�E�p��L�2�؉�0�~��8�����;���I�d���@�����Rh�ԟЕ(mA��Tm?*H,-T��	~�B !�TT������̝��Cm�+�8�|�����8���s����p����5��Ю� ]���p+�j��#�p��^�LB��P�x��D�7^ى}l'v�F���*�,��v����� ��jW��+��6�#��ܙ�{1��w�v��nk�sJH���3O�t�ԇ��H�Fnl!!!��Jؽk,��ǂ��ĆcǱ3�SFa�}:�r����ӧ�;Ų��{�H��=��1I���=e������׀�v��/���
�{��Z��������8��ۣK8]_il���̽*���J�(qB�@�-<^����J9[�U	17���x�:��:�{Y���<]&�-_�0�.�|ۍ�0��x:�&b��X����c#Y�WF��
��hң�Z�i�_���|�	eGs�}@�;�^8�H���;'�ur�[:f���N��$�0�$�$8��ɰ�F�� ޸ ^�����>������\Z�ċ/����������jFO#IEok��,�"X�H�)8���F5��*�'U�1�b��(�]�"�������͇_�������~����^��8~�<8�)T�>.�׳��zچ.��B�BB����/�l���
����}�g!\�qP���s�o�;��t�ܡ~�ag\\H�]��ٺ ���WχuOՇV��}�Y�JXyiU����+xq����Vd����߿|�?���[�_�nu��#^�ο
]�b��h<��.���n�S�;����/�c��?�����Oa�F�� ;۱K/���/��v_��֧��_����;���{ov��4��Q��$�]	�)���ֹ��B]���F���H�G��Z�����%ۆjUm'54��4�P҆�R�t*	km��'�D
K�h2���6�Ɠz
A���CI�.�_��?��m��>�'������_��K�?��?��#���O���Ň޾���	R��7�o\;��\�����Bt�[�Co?��s�߹��8�����A�갞�B��9������ݦz,�ҏ;���~��ef�93>�8���-p�	HA���9Q�taƉ���%��ً�`Uf��j~@-c�9&(�Ҝ��^�cQ$�֐���[��zM��sdm��S�,!�1(0�Y���J�l��L�#�e�W����hn�
��r5p2���W��K�L�C�Z�l���bI3�9���f`��¸��8?WM̘���$;,1CRܷ��^39�'� T�~�7XN�XO��"��	�I�&Z�4wAb���&]�����zR$�(��Q�e�f�")�*)8��C-��[6Z�y׌���1-�w�_�,�^��������&���C�Ԥ�H�nyP��f> ����H�R���<m]��
�O-�d-vHp�D���~�h2���D*O��4!�����kO>D��v$U<��� ��5�I3gx����5'���svįݠl3���E�p�M���-!:����U�gb�U���-��T���'��,j�R%#Tz��i�T��Ƨ~	F��n�F&%9�4Gi�����َ�d�.���^�5ʖmr�~&E�#�SPD-|��n�
I6�l�6�x�oU�5'N�2=�	
��r�#�����G�� �[0	���1��Ƴ��4Sl4f�q��Ql�a5Z�\6]�r}�|4�,�	5�W�qw������e����R�r뽼P#���x�6�i��3��,*����d�5��f	�C��Y)w�8_��&,�l�k��gdrL��
�L5Zf�F���Y�^b;	Es�+����m�ј���8�o���ԫ`9��j2!8��1f9�|�Tf�S�5�I�g)�8������xb�˻b�)��/�e67:�{�)Y��![�YiX��ZrP7*V(w���Q�� f�y������}k�}{]+�5,?��b��&kt�Dg~Dc��.�s��1t��?���p�q�G�a�`=��䰁�$6�Ǘ��8æ��MHuzZ8�ȶ��F��B;�%˃���A��l}��D�VtzWnP /�(fH��� �@�;�4�I�Sw|[��d�"�)�@1��-�'�r8�Md{�<6����ZȤ\�X�^�n m|>�7p�V����'��*n�]i%����D���X����Z.�hV#�����e��5p�i�2��%T�FE 񵪗�O��QOc����N|AWm\8��5������B>��]������Rt'q���%����5h�~��zb�r�xݛ�Z����M��Cď�5�����V7�_��&�+e�ߞ9X�����_YN�_�}�
�GW*>y��G&�d2_;�LH�>tI�Ȧ�b�^L�g��C��Mޭ�Lޏ!����nSl�	��{����v�%��~5=u;1��=f�UޯU��hc+��"�sŔT�6�1���"+�g�\�!��^L�ɜ(KU�����F]���|�e�"QIۜ٩ᗓ����{>��3�~Ն;p��漉��ۗ�#K���`�Aw(v���;��Y0u�0�f�niX�Ѳ!�C���wS��6�6�h���k���������^�$"]�3ŔU���v\��cHP{j��Ml�4W%S�My<BRf�iL���5��
�c�9�J��]cDz#��%�>s�
�#��������#)����R�ib�.,ӻ��� E�O��i����HA֦�ט��t8�z�tK��Uq���\�R/(A�&�)w�y^2��`Gks�,Pg�\�z�7�]I]���y��$y���j�ܰ�dQ0�E��"���"'���8x�Zz�aA�u�n�Rg����[����m����u���A��� {_#��_���}si�߸	��M�k7��*fs������'�K��P��g�z��$k��@�By����&��`������j��ٝl�0	��$0`�ɮDUv�x;��-�3����yj*dDM�sn���kj}T��av�r��c�:���`l��ʍ��ąG�P��O`ʨlhG8#����OyN<�7�C>	?�t�oR���xq6���n�a&��^���lQX��m�W�V�p�Y]%5K��ˏ�e��]VQdZϠ(;�z�
��M�%��| �l���Ri���96q���8��[�������'�[��n��g�~�*x��_����ՋS]��/�-�[��5/�3��랽�F��ϳ7BV.�3�Yy4|xϣ���hh�����>��/�+Q����c_�y:t���ݞ�}��{�TFjG��:�ty\��[����ck�<�����G��@O�!h������ڑl�u�}�\;�M���O��G��W8/�g�(qWVz��Lq>���n����X�I�L7D��!(��~�۷�G}��H�k ��cu�{Ro�G!<�B��ս�Ch�P�}݇^������n<vb���+"l�'���6��l`��6���$��a�۸ � 