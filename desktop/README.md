# Home folder structure

In my opinion, to best feel like home one needs to establish a clearly
predefined folder structure hierarchy, and stick to it to always maintain those
bytes tidy !

The 'specification' I came with is available to check and adapt to your needs if
you feel so. Anything in this folder will be used to create the folder tree on
the targeted system.


#### draft, wip, todo
- jq

### Fonts
- cyrillic


		<tr>
			<td>`xorg`</td>
			<td>Graphic drivers ready</td>
			<td>Graphic server. Does the job but why not to try wayland some day...</td>
		</tr>
		<tr>
			<td rowspan="2">Fonts</td>
			<td>Nerd fonts</td>
			<td>Window manager and terminal</td>
		</tr>
		<tr>
			<td>Noto fonts CJK</td>
			<td>Asian languages</td>
		</tr>
		<tr>
			<td>`dwm` + `dmenu`</td>
			<td>`libX11 libXft libXinerama`, fonts</td>
			<td>Tiling window manager and app launcher by suckless</td>
		</tr>
		<tr>
			<td>`st`</td>
			<td>`libX11 libXft`, fonts</td>
			<td>Terminal emulator from by suckless</td>
		</tr>
	</tbody>
</table>
