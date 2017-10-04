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
docker pull hyperledger/composer-playground:0.13.2
docker tag hyperledger/composer-playground:0.13.2 hyperledger/composer-playground:latest


# Start all composer
docker-compose -p composer -f docker-compose-playground.yml up -d
# copy over pre-imported admin credentials
cd fabric-dev-servers/fabric-scripts/hlfv1/composer/creds
docker exec composer mkdir /home/composer/.composer-credentials
tar -cv * | docker exec -i composer tar x -C /home/composer/.composer-credentials

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
� ��Y �=�r�Hv��d3A�IJ��&��;cil� 	�����*Z"%�$K�W��$DM�B�Rq+��U���F�!���@^�� ��E�$zf�� ��ӧo�֍Ӈ*V���)����uث��1T��?yD"�����B�y"��H8(�	�� <P���lh��6aG���-{�+�2-;�E��Y��h
�v8 �'��~3l��<7`����Z�IY��F���:2��c,�P�ش-�$ >�b[�v����F� )q�;:,����|:��?z �~��+�T-~��,>o!�Іe6�� ���c9dly2�?BȔՖf�* �ĺNVB��lZ1X��R�E�H%��4��ݦ1р��tw.ꇙO��i�7��dҎL\�t�x�o�zVMMY4|Y���mwA����4�:�_XD�&U��:�"�&�C�dc�����l��,�JVQ����]���C�9$�"����5�?�CZ��Ӯ�Ͷ�x�����:�#؉
aa��S��g��P\���&jP��V�jg��ΡYs��E��b�e8����&�W���㗖�Ȁ?gԟ?usd�l�Z_}t�eW�c�L�3G��݇4Q�0�m)�>�w�P�Dl�����(�9�]l6�]QQ:�g=Х�L�[2i��=\�s[�������Ɵ�i��۠N^4���Q���D�DIG�����d|��ߌ��q�p�p���jܷ�����/�t��!)%R.F�`d����}�jF�
�ga�T��oEe�Tͤ�|��˥���a��H�>�y�Ń���J>�u��A��֥�F�!�T��r~V��k�_���ˆ�߆J֑���ƃ�������bPO�dm�Wt�9���d��;������G3Ho#�X�l���`Α�a���:H�mz(F�N�mǤ;3�ݶ�u�M�f�bE&"�5���i������ކw� �"Z��T�&60���X���>�mJy��lN�9%�n�tMA��ږ��4�/�E��$�#UG�~~��A/�:V�JO�x��P�v�7�md�ݰ��s��a�ٷF�Pu4]�ASih����|>������Z@�{4Z�ɛ� �����?��'�R_�Js�~ix�>"�=�M=�!5�� ����&��������I�v�.��/H�N��� 
�Z����?��^�9;�vڠ��:��
L��D
0�Ќ�襐�+Y6nonq�w$�>�T��|�8��Qo�H$�w�����ה�ATR���=J�fo���}�G ���X?e���ƃ����փs[/�A��M�f0��W����,����g��%� �@�sQ؜�:�a�09o�;��[�a��x��.�4��tЮ̏��ag6l�"2��:呁}��=�"���)�c26�zp�$���]�t�cE�`��!Wp4�U�}W1�سd�\���t-,�#�݆�4 f�������d�	�l���:Yo�y���y�z��l�w?���k�	��*m�9�eO7����5 U����#ĩ����Լ�Y�u��K��ʑN�Z[�/f��Hv�C���?�pt��X��|�0C�Gk�@m,�Q
F��_\���\?)9:�q�3�l���OO�v��;fb�稷�1a�u�Ӥ�� �6{\2[��u����R��=*��Lt�	�ϞgW�v/�_�!�_�.1g�wE�ܴ/f�ǩb){�y��͞�;� 48���W�I��m�"��4rLV����8�[h>MB�n^<�|D:Kw*7�[*���y9�KV��{=�6��blZ�,�jm��D�]1쎁��&�}�w�/���s�G:�x�<�����s��pK˹]�y�C`8�*2y������-"�K�d�@�'t��V�d���|�Sq�qY��f��Or����_!;vr^D�}������]������e���4�� .��?��ECѵ��^��g���=3�-�dAt�|mմK0��𰃞e_k�{�������2���?������\,_�ù�y������n���	
^v�#DCS�
E��%0��7Ew�� {pӲ2Ml�mS3l�h���st�Cj�M�u����1'{�?;���Z?/>%��1![j86{��h�|wIO���g٨h��=k�s"�Y��ӿޫ���X�M��˱�gҙ[!�.�����Աu$e#��>��<~�lx���Bl�	��=�<�1�a�!]�`����a�u��;g�����8]���,`�.Pt����[������/��Qi��'���Z�?>�_���H��
���ㅈذ��R��GgD�з�^�s�p Z{<��xz�q� ����2|�	[AF�.��wj;JC�NTY������,������`8�����/��[�#�b[Z�a��zob�)>���Ǐ
�/�U���������ȴ�K��:�w%p_�����]vCd�3}z?��v`� �|ƞ2:�F0��k5Iw��=�*��g( �@�[�v�I��,`44�mN�s7�
�m�#H�������vы��K3�-ef��k��e�`���l7Ɉ��K��N�1QG�_�Ʉ>K3qx	$fdؘJ43s�D���2f%Ƙ�0�cr�S�d�_��R��d��O��+e,���s��(�YW�<�"�G�ó�y7�ثCA_Px�onm��ڸ���J���U�����\��/��Ax��_!�>�	��u��J�����s��7_��o��?�������)���O(TI
ƶk���R֪5Iَ�"�j,(�I"�"R�I
�b�XL�F����v8��_s���&�!o�+�wr��k�!�����WԼm<��9�%�aa�֜��?o��1�`��o�뫍�|5I�߿����~�r�Y������n�|�G2d�����l^Mk�O	���q��F��x�������^y�.��ýSw��!a��W����t��ic���\)"���p�����ҭ�����Nc����$}���?h�M����7S�N��;׼���9[�m|�AE	ª���jMP��!a��C5E�n+1)B�'"�*��$(P܎�XU�B����&�!�k^AD�֨���Q��2�<H���l:���)V���e���E"!+������z�(�C�8����~�p�����iv�e�.���*W�BAnfd���7r����e�J.���cB��h�Ռު��8�$u���+�3��<&ϴx潡���iP�:n_f��[�S�X��*圽m4�o��Y)|Q
�{I�8�r*�o�7Z31�{%�++��E6�+g��r6xB�.X�0({o�\ī���MN�ǅB&�}s\�J�sd�����~!����YGi�ۧ��I.^pG~�˿7*���M��NO��m��z����Ð�ݓ�Iц'a�̅�+�u�I�J�R?h�;�r���d<���>fJ9)&�S�D���M��BV�g����xA�4/K��1>�D�o������I�y8)��������qT/Vj�p_�OC��i�\�,z��&��h�ʩG�ș��e����r9~��%���j������{����s�W����vJ���\¢�R��B3�ؗ��y�h<��7��A�����n	���CSH�#9-�&�G����x82��	Y�˹T%�-$$k�yo$R����)���U,|4����d6�J�I�{�$�@=[/��#���Sq��0���bQ���x{��;���KH�hG�W���{��|*��!|�������Q?Ќ�#�1��l��AtsC}A#B�	8x��L�@��ۋ�=���'����nM��Ǿ�����h��OHd�_����Ø�tT�� �S���)��f��M���xF�B�C
uA�v��XĴf5�;;������3'����I�\�F�i�+!�E���
�|���4��0}yu,�:~YE���tܬ�
�p/��Q�r��h�D�Ĩ`��(9��8���^Y@-�5p.�Z���ܳ�ˁ_���n������>��w��{�kx�˰��Y���s%0n�+�lb�����T�t�;�Hȅ�QHR.(�B]N�h�L��XN��]�ԝ�%�7�6<j��r�0}��5SHq�go��t1��X��mq��yevː��⁥u/��^ۨ��0)�ww��t�>���v��׶1,�iu��W��f�wXZ�\<	��,.2ϑof�d]EZf�"b|���g4��(��wঽ��g�5�;`����D�����H�f��$QM341�k4��;��@�N��xQK��*���]��i��%N�y<mȳ�� @��f쀱�*V��mS�|����%� }�@gT���,����%�~�ް��~�n[��A�<<#�{k.��m���<���Ge^F~Ĺ�၏;�F�b� [Gk7X��a&Yd���^D�4�A��]���L�ᬠ�ӣ�j�d|� Gp ��Bt��.4X.%RʈL��+W]
6lz �&��i!�mj�"�S���z�mK�]"�vb*tՓ�gS�f}t4�����~�����4,/�+]t���3l���y�TԷX_��r����hB��b�󘚊���Z7�'���.��]m���Č-���?|��'�\N����D�ܴUz���O�u��f���4�$5�!��W�DV�2Z�=�������^�ƤLk���� OJ����C_q��R��86A,�5l�G ]H�Y1X%83�T����S.	|<�B\;�݋�T "�6��JإH�B�-F�"���G�1ʀ����7�_���@�Sy��@O;��lw�b�z#���t3��2K6Y��W��n���e�6Tt	6K���G��P����U��l�Ql�>���o�'D0��du#�v�*C:14�t˱:!D�(�c)"�b06�T����y*��dM[����ꔶ;:���h".�htB��*�ݮ6��:�`]��tX��9�	�e�q3���M�}��#�!��%�����,]�~�`~~��ĩb���Eߛ���R�
���g8'��*��s�x,��zĆ;�@K6џ�[G�Ж�����6��E)$L��#��޵�:�������"5��`�P�t��T���I.SR۱�87��y��rb'q�<n��I�X �h	����쐘[�fB��`�;`>Ǐ8����-�9��u�}������?A�{I��G�P�K��������_|{�W�����s��������_��7��K��q�s��,��8z����:�1�
�n]C���ga*Ɋ�I��"����p�)��B����12܊�BFe� ȶ�r���$��G�������7��'���G�����}A�������!������}���V����﾿`�������{���!�5����������i���� 톋! -V h1e��
l���F��cCK�R
���&�ҧL�s���r�B��{�����«\p�CW5�e�
�ݨ*�%0#�5�:�M��i%ab��&�^}.�
��kHֳ����=C��0�/鴍@���V��`r��x����|��́��u3A�w)��Ek�Nq��6�q��΄b�L�0�)7g���A%\��f3Y�։�!M3فyX��g{��;�5��~���:�F�}��_���@Μw��s�0���X?ŗF�˗ٱ�k�A'r�B��:�7��2���J��9S��2ee$�R�-$0��,by��B�Z�Nr �Q�K[�#��$�$��ɚ0�hg.�4��-�1����)t����Gt��"n*���� i�I�;
S�_-2�a����71�lѪ�H��b�C�r�`��d�j��X͔��qg��r��/O3�N�OִV���Y�T6�tr�g�&%��Frʏ�C
m!Z�K��l~�]���t�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%rW�%�py	c0�"o�R4x�$��?\�(%��cO�p���cLo�S�lӊ��b[���vV8�rr�D��A�C!U���A�ꉚ)��n����۩��?�n{���C������9Cd�x6d��FU,�zm��G�j���M��	����sS�<N��p�hjr,_���hl��6Y��V?��n�~"��>�ӱ0&!�2��-k9B�©�D��&ފ�<e���s�B���S�p,�#S.�|&;��ә2k&��j'�.Ȑ���d?�ӵL���Z6�'.�;��T�Q�MZyD�ڬ�����,J�K�̻��z�������oY��q�ڣ���-���
`�^�/���^	��g�{q�\l��a~���E���;G_�}���C��5�S�E/��7�@���˛�7�y��X��> ����� ��@|�?�ƣ:��<|�a�z���?�R�e��(������,'�*�g��,)�(��������u~��K�Ώ�|�2�`a9�,%r�Y���+���X�~Ʌآ�`rGt�Ʀ�	Lٕ�9 |�
L��H�L��(�Y)�aL��,�T��*0K<��L�8�>f�y%�+ 1*��N�� ��߬����o���E�M�����1o�i=ڮ.k�D����te�GM�&�9[�D���jY��I���d:u�N�t�o0"�i
�d�SP�8#5��@eh����v�8^9�D)9:�$�|���Q�J����>E�e'��Y��UZ�)�~��l�b�<TpLTj�p���,�F6т>��b!���Ƙ^`�8�e�J7�)Ǎ�0S�{�0����N|�ۿ�x�[W2M�M�P.��(ϗa��p�LN�L�����p�_����M9��+����]W?"W1�+r!��/�=n�e���6����3�{fVz\�ew���;m�]w�g��~��M��pĿ�\�C˞l�j5�7fI�g�D=���l���Ò�͠���Z(���2�g�S�(F�,1��\��<=���^mdi�T?�fNߡ�Z�M�P�lC9.дyj3K��L~Dw���@�:�|��$R�YGkO�#������Z�`��|�O��-U]�*,�.-H��V-�W����NU�bYs�Rd�F�P�7�yC�R�bQ��Ê�h2�l��)��"t�5\�W�u�~�1B��Q4�,<��M��W�DV�d�R$Bv6(��552����RHزJ�&�_E22���H�	�~Ԑ��I*�G0�2AVv��D��c�2)s�U(��{�B)���B��:���uJ+�9$O�j��pI�?��:ݮ�Y�P�;�<Ǹ�ѱR=�������V.�*�dH[F�3�.��Qn�PW��P(�r�.������piJ
^ԇf�����y�S�y�� }),����)��f�R��;�4YhΧ8)W�tC�k��<O�HX#H���&��Q�1K�:6�MS`��QXbe��Bl4Z�X)�j9�2f�����.����,��.}7���t�
��x�2���|�B��K�C�-*�1Q��b�#7�_F~��*C}����xxySi#/�c�g�huK�R	�x�y���s���σ^�o!��<��()�n�M�b���S����Q�4U�}H���5�I\����)I!ki�3�*��i�8"�����8Xɐ�%��s:�Sw��V����G8�C��D�uE��Gȇ���)z��p/r/�r��f�wHwI����D��z�_�����Q�-��~�����r�@}�l?t\�:=	�j��@��kH7�˝AM%�@/�r�ke��G���aU�Ki��]�ȍ;��� �H;�q9#�O`�E�O�#c��gv��~��������?uް6�B_ː�K���<~�:����>����غ]�-z�:@N�J[Ŝ���Ɏv�l>P;������cu�euɆ���ãqя�E�#~?zX҂�c�|�� Sk��~��B-� �g�+bw��/��7���B;�z�M-�18��b�`��I0�A�;�jrp�X:
 ���T���Ԟ���pe Y|�B�Al��ja�C�٤�$����(�Џ�����p�Dd-:����>�����Z�i�zW�x��L����w��~t�W��"5�Z�,� ~Ҋ�y֫������U'.��&;��X2����ں���x��U��.�#��+b@}�&:���Y,@'�L-�q�Or+! l��D�Ա���#�F���������	�˭~f@�����9���O=����3[��\;ؐ��_����bS��_��,���UM��d����s��EC��ӡ#�-��6���҂��u�&����-o�C�b�$4`en��f#�O�(�-`��ɏ ��$~y���|.��t��qp��"(�fK�-�x�Kv��V�>aP�:W�&���+���h�R����E�<����v ����{���]�LR5�2�U�?��!��q_j�%v�4a� ��m{[�'<	^��v�O1��1��_i P�P�X�A?MI�#�T�l����Y�I���k)�΂�������2k��I .�rXǚF��A�.�����:�v5`U;V&k( ?��=n�ܩ�!c���5�SK��f��aM�=W���v� �p?2m��_Y�LTI��%�����ӕ�s��Zv�E���]Z_�b�F��ދ޿ �>��	p�mX���n�����!�"T�i|��U��m��j>���&�ĉ�3#��ON|-3�Q��Ú�C��y�M�$p��:��u_Eٜȝ <t�ϟ���Ñ�n��mm�i��<�@���#V��9�1��.���E�[@�BSv6��
t"��{��}���f*�9����n)�pḡ|zl?�@�)����1����Zl�X����:�����v��+۸��?!6���v8��G+��$��l�dG�[V�`j'��2�6<�{�	�)��8}"c<C���Ρ�K\���oYڪbGg��.+>�%��5_�Z���>+W4t��o֎D���T���&��D��٦�v���q9��%�h���c��l7�1J
���DPҙ޷P{���A�;�
|����n�I+��fl�7��z����(v,�7av�}eq�*�ԤH��lb�(�%'�p�b�$QT8�D�(UBRS!$��5�ј�(�DI�51�'M;��	�96�O�O�l�,�m����)z�sKBO�;g	��dg�=�]Tleܵ/�Y~G�+8vW���6Wd��E�I.���Y&��p.�LV��������ei�-r��3ZW؅���%�$pb*�>�G�Wd��^����.T���<�>��]�D����@�g]�\T���#;���:hg��P}�B;�ѝ6!-m��:Ӻ*v0:�2����m��6��ӵ���vn�(t�	�nus���w���KS.&��(��{<W� �'�l�,�q�B���)���s�*��,ǔ��Y+��e�9>+>���	����5:�&�d:tl����>aI���E������v�l£�;����U4�+��\6�'ϲ�X�Okt�\6:�_�]ot�u���L�S��<-��yt�c��"pl�*[i����H3t�{!OY���\9�bgL�_��S�X4�B�����Q��3{��䳶���,��/�7��]�����������͢��m7�o��-ۅ~Lv��
�.+ce(�g��;�ڼwI a�R�nm��\��
ɻc����p�8b��r1c5�8B
8*:�����n�߮l�n�%Lb�C��}�;��6��h�����w���H/|��d�m�?DD����#���I|��7v�����������t�������������B����*��6�?	��>Ҿ�?�y�'�����lڗ����/Nn~�����}/����������z��o��Qz%�?rG�������/�O�c��l+XkG�2nɎ0���v�l)�ԊE�xK��X�j��H�	G�&&+x��Zg�ˢίvz��!
߶����|��f����4��5uh�ÑVF��s�"��є�0p��Ns�|]W��ʌ���J�s�]�� ��R�9,�"ch$[\�O�Ѳ���m��!iY�����I)]�M:�⤫��Sf5IƻcTc/����K;���*��������/�ml�}��v�}��m��q�p����*��q�:��}�}�����=��|:�������u�GF"���t�� ��{
��� �����?�>�9��{I����Wq�pJ��t����򟤶�?u���H����~?;�D���%�/��	jK�����}�C��C��C���c�ʺE��=��w��y�x���TDP�y��(*ʯ�4�U���R�+g_��TR�n������G8
��؃�O��(5���e���k�Z�?u7��_j���Z�P�S���'�����߸����������s���U��T��s�~���d��ׄ��i]W?�����>�h�û���O�c��y�~>�UB����>ok����1z*H�r�5�B힅u��Λ�f&;�>���4S�b��[JW�*��~�;���̋VK?��6?���M_����o�}��>���l��Ֆ�䨃���o��q�T>OH�h(��ܛn��y�%�v�S<�͕��SW��=r��U4�M�QJ�Y�K�B�"QiOV�M��ql��!�ް�1�h��/w�����3�ef�w3j����_j���D��P�m�W���e��CJT٨E�� �	��K�?A��?A�S�������+5�Y��U���k�Z���{��O���Z���o���Q�����Û��֥������	���t��h\U�U<���������W�������>wƣ�&�}Y����:v�4䩇�o�gCq�E[ool�k�Dp�j��#���\�f�FN�A�rL,8��l;czF����KQ�lo���kr�T�#��C^��^~�	5����~!�F�$�_��ȭ���6�y��CC��*�GT�c�㢻��M(%�f:_jSf'脠7�
�FM>��։��Ùk��0b/WLt�QCɑu(�xv(.i��>5���W�B�a����@�-�s�Ov!�� ��������ī��S���KA��?�y��(,�Q(��H�B)��B4$=�c|��}�&\��q��Q§}��Q8#��Q����9����Y�s��)�A���i$K2��+�S��q�;��6�F^[|��7X607Gr8?z��0�NV���01m#�y��-'��q�7�|�!D/�1R�Er,Ivo��axi3������7�@��{Q��?�V�����t}+E��P�U�Z�?��T�������RV�b|Aԁ�������;�lT�q܌#&2��3��|���������q>e�Yr��r����H�͘q�sFw�T�]�hΑYnƾ(�]F�0���H��l�W�Й�9^�t����!�J6-ϡ��{/�q�����5������w|m�����U����/����/�@�U������s���_xK�9�E�E����AD��"���$L����.�?XT��_��-���f�Em�� ����8 ���}x�E�����_��*r=��3 x�8Kȡ���Fo�j�l�%�tv3d�h5��+��fa�Ұ->ވ��Ǩ^�w]Oډ��s.���-8}�Y/"�ϑ�1�q���9O�W��`�-!ׄK=�"�%\�'�/�q`@w�N3���>��c�b��B�F"�e�I�0��N�j�����a�5�!�6�ʙ(��K���0y����|^�Q�G*��i���n���T�q<�IJo�$�l��i����XX�\34��u	�_�׉�!���6f��$�Xs|^Z]u;��hP����	��|���wa£�(�����C��?(����2P������/��?d��e����?��B������������6�	����P���8ף)��<�dQ&pIu9�ui��Bei6$\/���8�\H2!��n����:����Q����_9����òPR���玅#T��/�$='��vD����A�/��P�&i$ΦY�-�(m=l;챑�͚�i��w�>��s���G4���Jp�=<t4�ƹ�x'r�Ӳv}�X�`������#���O)�|��F<T�,�2�������/���������P���:���:���j��\u�����?����\���?��N�����7�߯�__�>������8M�}N&L��˕q7����K�{���q}������1�gf���l�g��|l��{wL�;Ղ��9��>��I0���dZ�(�}O�������������ڳ���j��8�4�a�4�X�d�LC�!�s;�Յe	=�'�ȵ�+=g�_�m'��1�-�w�{`E��ݰ����6]������[��]�C���~*;�5�C$3ՠQ���5I�-8j�5���H
�������4#%2)�N�z�$�DN]Y�5�9��d�u.�E�c��n�Z�e��:迋ڃ�+B9��w�+��������c�V�r���:���i��J���7���7��A�}��ۯ2� j	�������C��:���O_�PԢ���K�P������_�����j����Q�e�������C�~���(����'��/u�E�����������P5������8��*T��Q1����+������RP��p�
��_9�S����RP/��p��Q��h�	�� � ����#?�Z�?�������P��!�����j������I���ZH�C��(�����R ��� ��� ���?��P�m�W���e��C8D٨E�� �����R ��� ���Pm��@�A�c)����������_[�Ղ����8��Ԋ�a��tԡ����� ��0�������P��=��2P����>مP�W ���������p�Cy��c�Ezh�����@�˅3��X�#q"���.�$�˸��1�˹$I1��>�����O����O��`��.�Tyz��۝K���S*��ܽz�����z���M.^z4���jb�Po�W��%�~1T�~�y]����(f��S�^-Wdň\����B����Rg��
){���q$��;IVq�盒}8������P��&~/��T�/x�P��?�V�����t}+E��P�U�Z�?��T�������RV�b|Aԁ���������F�����5E���,;�APۗ�����O��R�Y�ro̕^4�~��w��ī�d�&s���D�	;��mӞo7l�izj���V�}O�a��r����`.S:��E=��w翃�[jp���?������P��/������_���_�������Xj��.�G�?���[����������n2"ı��7���GV���7���W�gmw�v��NK��c��'�H{�n�Z~�!�ܖ&��4�"���H y�q�t����k��1�3r���H]��(��vFd�~�{��9�[��i�$G��8zy��O�N���vK�5��^�	��.�;~�kț�}��;�(�z�8$�Ŋ��
�:RX�'}��g:i������k�!*���[N��g�&���@ٻ��Y�z'gf\��[:*�p؆빉��r�o�'QڙP��%���&������wW�'�?����-������/����-�q�_���ן����C����?a��|���)�F�j�2����?�b����(v��%���@9����	��CY�����k��Dq
��2���[������~\�f3�^0w	���{ү��hI�y������$o?;n��G�z�+��~h����C>z����C�{~F.G/=�|�ںt5!�Y�ëuyu.��%ȟcK�o	���*�w�U��:Pgv7�a�|UL�222���x-s;��.SY���g��a*.+��ϙS�I	���+�NF�6�*��1F�b�K06�X|��E�>YyO�;��sW�˚�T�~�K��f�!O�l]2:MM|zORdĂ(0vojm��`l7E��0��F�=6;�X��ɗv��%����e��/	2�����Ed�2����јw,~2�N��F�N�Xb6"%b��
�y��w��@��F�:rS"Wg�q�1g��U_�}}�j�����?����r��Q�Gc��13#q��>�^&i���$���l�3$��\��h�����07D},����B����������R�+��%:��gP���PDv��t����vO=��Y��!|����+V+�G��U����{�ٟ������������:�?�!�������?85F��M������A������^q�������g�}+���0>�23���̿��\�\���[/urN=yW������6����w���wxM�o�_����l?�}��A�{�c��0Z��)����p�Հ[cz�*޴ӈ����չO����,m���C�;�u��J�]m?䣾���C�~�'�X��Q�۳vC5fﶓ-�D��4m��|�+�e���cߏ�'�y9��=̚���C�p�I�R�D(�5�l��sQ/?U����i�5��&�����7����M_�VfswV������n��������o)(��O��O�!ͲJ�X�v�|��ń���(sY�E/�_tA�b��uyc9̿OD����?�������+��V�^�m,�Z��9,����p�6N�0ۡR��e�8Ѣ߉_����-WՂ|T����^|�������!P���@��E���?�_(���^w��Z���j�����P2�?�@@;�6(����������)x��#^��o�?�nSQ쵡z=�����0��?��<������{}�c��G�s��>��( �D9�,�Ф�Y_�g]Z��UryLy~L��X>ZȽ[�
�h��ֹB���\�ӗ��&���޹?��m{�w�
nN�Թ���!=ur� ����֭@@| �:5����;�DgҙI���>UI�"l���{��k+}��u�ו��^�y8���r�θ։����<t�v�Ѭ�uݾ�z 
������T[UL�=��,�mfe��mW�nɑ�+b���t�j5��^����������RS��y�g)J�X�{�94Y��vŮ�{{m�
�x�mؒ�4l��[edK�ڼ(��O��*���Ƥ�1���T���`8��j�߫�X��x�mg�j���G�+�$�ek%�������//��JR$=���WRO?s��?M�?������	Y����^�����<�?����,�A�G.����O��ߙ ��	��	��`��U���C ���۶���0�����
��\��������L��oP��A�7����[���տP_%�[d����ϐ��gC.������?3"����!'�������+�0��	��?D}� �?�?z�����X�)#P�?ԅ@�?�?r�g���B��gAN��B "+����	���?@���p����#���B�G&��� )=��߶���/^�����ȃ�CF:r��_�H��?d���P��?��?�Y�P=��߶�����d�D��."r��_�H���3�?@��� ����_�� �?��������m����J���ʄ|�?���"�?��#��!���o�\�$�?�@i���cy�	�?:���m�/�_�.�X�!#r��GS�I�%~�jF��yn�[e�dK�[�k�|ɤ�3,K/k��1�2�9�c?�ou����A��ܥ����������Q��������]�bS�[��d���$=���uQ&c-�vm�;mL��-��8��XPkq��4_�*�#6����vSZ�t�z�t�v����tX��vX
����5Za-ɜ��'�����5�7�ݎ]�F���-N\�vI��J�=(�Ȋ�:�����B��9#�?��D��?Zìo�C��:����������D�
�K��?t�H�O��&-�j�=&&"��|��3�-�^O���j˝=�?���h՞�ڃ�F7�Gnk�5lX��a�p����X���;�U/Ķa�&���1�W��R�ڜ^ɁM<H�v*�$��^K>��"��"e�oh�F�36�_�\�A�2 �� ��`��?D�?`"$��]����2�������g��ݲ��懶����ȑ�b��:��6�����S��5q&S������׃m���6�T����]�$�vw�z�k�h���I�/��a\�X��CҚc����̫N6����ms������v�R�8��X�q���uv�O���U���-�V�_��v�&v��c�B<�~������81����fU���J��ɇ������	NU��ө�l����Qk�2���r�0�Me*�q~�����)�ұ�q $��w�~�4d�����݁��!�Z�~Є^맷�^���b��*޺���=rJ������+�d�?� ��_���A�� 3�z���	���G��4ya��<��H�?MC� 7�?�?r�������O& �����n�[����3W�? �7��P2{����������@�G���o�\�ԕ�_��2��+@"��۶�r����2r����#r��s����d�7�?Ni���9�C�J�� tĎ8>��|o��-�"�Cd��aĵ�S�G�>�~�����]=�~����܏4�{E��)�s��y������~�E'�׻≪��'qj��w�ڲ���3�7���joHE��Ά�̜���i��F��qt�1BX�Ƨɦ�ڎ⫣4���y��i�ؕ�_M��6�(�#-� �
<i���p�Lk}o1���$4��y��31���D֩�b�ٌ(r`Nxf5iK��&Y�膛�06�FrԦ�^�dحX�]s����l�>������\������������d ��^,��-n��o��˅���?2���/a Sr��_��E��&@�/������Z����D ��>/��)n��o��˅��$�?"r��W����&�?��#�[���������n�^������ʥ�ڲ������?|�?�e�yx��76�����~/ {��S@ink��1`:nC���R���=U���v��h��Y�|�o��D{�DU��4�-��т��ڡ^���V�˲B>������$�?���I ��Ћ��'(���.,�U_�R���D��9W��[~҅E-,��֞,�]Iٰ�i���Z�L�a���t���C��9��[�ۊ���ӻ��\�ԕ�_��W& ��>-��%n��o��˃��+����Y��g�ohE޲8���%͜I��XR��bi���R�d)�"5��,�0u�3�%��s����ߟ�<����?!�?~���~���-�әϟ��L�TK���^?��zm�Z��iT.<��y,�	M4�v����v�?��^�ט�b�x��EMk��s�;���<;j���i>��xR��@���!��h���<��P�H��t(�p��������Ar�Z0qQ7�M���?���ǻ�x���Y�9�U����b����Z��N	_����}����td�����}��4v.�&��zh�Y̏��ꈝ�����1?��Ӯ����e�`\������M����eh��^K>����/�g����������E��!� �� ����C9�6 �`��l�?D|�����-}���ύ�}�"��G�-�^�t������i��� �y!��9 ���u�����-H�T+[��z���jQ3G���OelE���GG��O��bSl����:��C��CU�S�Y��m��$�N_�yXj牚׻Ov��x�J#��bwX�tL0���&�M��|�ZIItr��=l����FC]-UI'd��Q88V�UD2���{�������f5��k�a�4��J�Ӷ�g{��p�HS��WW��S�f˗��'w�.9�
ǵ=;����Ŋ��?<`���Uh�������jcD��Q����p����L�������G��s�����>��O2������L�;���s�t��h���=u������&Qԃ�^Ğ"}�j�ǎ0�x�W��~�!=ܝx��6q���i�M9���	�;o��H\{�
��t�����z����(-4�5�χ�39��?/j���ܱ��k��?o~�K>�7����D��-����>���}�A�|������"t�%t-\`������p��-'#�/�'����z�>1͝��XhF���O�S1#�H6'�����&&������\m����?��@��ha��.��xs'H���#VQz޽�n���G������"
���~{ؓ��K�߯���~����ϓW�Q�Ƿ����w��v�������y�"� ���w���ė��7��m�����yz������x���ڜ�f��'<��ǧ+��q-9�g��>��E"|��u��׉�����N�L�KA�����@iV������ �$w����0�Xx��_���+�M��ͭ�ٝ��%>I����s0�7̀���z��?��y�8��ï���'Y2诅9mnb����ȧ'�z��[���������*�Oj��;�j�c�ߑڭ�"?vr'�&0��T4�k~�I��^�0��t���/��L���{���&�(                           ���J6rW � 